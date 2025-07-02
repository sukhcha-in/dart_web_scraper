import 'dart:convert';
import 'package:dart_web_scraper/common/utils/cookie_utils.dart';
import 'package:dart_web_scraper/common/utils/http.dart';
import 'package:dart_web_scraper/common/utils/random.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/parser.dart';

/// Makes HTTP requests and processes responses
/// Returns Data object with response content or null if failed
Future<Data?> httpParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required ProxyAPIConfig? proxyAPIConfig,
  required Map<String, String>? cookies,
  required bool debug,
}) async {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: HTTP", debug, color: LogColor.cyan);

  // Initialize request parameters
  String url;
  HttpMethod method = HttpMethod.get;
  Object? payLoad;
  HttpPayload payloadType = HttpPayload.string;
  Map<String, String> headers = {};

  // Configure request from parser options
  if (parser.parserOptions?.http != null) {
    // Set URL (use parent URL if not specified)
    if (parser.parserOptions!.http!.url != null) {
      url = parser.parserOptions!.http!.url!;
    } else {
      url = parentData.url.toString();
    }

    // Set HTTP method
    if (parser.parserOptions!.http!.method != null) {
      method = parser.parserOptions!.http!.method!;
    }

    // Set headers from parser options
    if (parser.parserOptions!.http!.headers != null) {
      parser.parserOptions!.http!.headers!.forEach((k, v) {
        headers[k.toString()] = v.toString();
      });
    }

    // Set random user agent if specified
    if (!headers.containsKey("User-Agent") &&
        parser.parserOptions!.http!.userAgent != null) {
      headers['User-Agent'] =
          randomUserAgent(parser.parserOptions!.http!.userAgent!);
    }

    // Inject dynamic data into headers
    String encodedHeaders = jsonEncode(headers);
    encodedHeaders = inject("slot", allData, encodedHeaders);
    Object decodedHeaders = jsonDecode(encodedHeaders);
    decodedHeaders = decodedHeaders as Map;
    decodedHeaders.forEach((key, value) {
      headers[key] = value.toString();
    });

    // Set cookies if provided
    if (cookies != null) {
      headers['Cookie'] = mapToCookie(cookies);
    }
    printLog("HTTP Parser URL: $url", debug, color: LogColor.magenta);
    printLog("HTTP Parser Method: $method", debug, color: LogColor.magenta);
    printLog("HTTP Parser Cookies: $cookies", debug, color: LogColor.magenta);

    // Set payload type and prepare payload
    if (parser.parserOptions!.http!.payloadType != null) {
      payloadType = parser.parserOptions!.http!.payloadType!;
    }

    // Inject dynamic data into payload
    if (parser.parserOptions!.http!.payload != null) {
      payLoad = parser.parserOptions!.http!.payload!;
      if (payloadType == HttpPayload.json) {
        payLoad = jsonEncode(payLoad);
      } else {
        payLoad = payLoad.toString();
      }
      payLoad = inject("slot", allData, payLoad);
    }
  } else {
    url = parentData.url.toString();
  }

  // Inject dynamic data into URL
  url = inject("slot", allData, url);

  printLog(
    "HTTP Parser URL after injection: $url",
    debug,
    color: LogColor.magenta,
  );

  // Make HTTP request based on method
  Object? result;
  final useProxy = parser.parserOptions?.http?.useProxy ?? false;
  final dumpResponse = parser.parserOptions?.http?.dumpResponse ?? false;
  if (method == HttpMethod.get) {
    result = await getRequest(
      Uri.parse(url),
      headers: headers,
      debug: debug,
      proxyAPIConfig: useProxy ? proxyAPIConfig : null,
      dumpResponse: dumpResponse,
    );
  } else if (method == HttpMethod.post) {
    result = await postRequest(
      Uri.parse(url),
      headers: headers,
      body: payLoad,
      debug: debug,
      proxyAPIConfig: useProxy ? proxyAPIConfig : null,
    );
  } else {
    printLog("HTTP Parser: Invalid method!", debug, color: LogColor.red);
    return null;
  }

  // Process response based on response type
  if (result != null && result.toString().trim() != "") {
    if (parser.parserOptions!.http!.responseType != null) {
      try {
        switch (parser.parserOptions!.http!.responseType!) {
          case HttpResponseType.json:
            return Data(parentData.url, jsonDecode(result.toString().trim()));
          case HttpResponseType.text:
            return Data(parentData.url, result);
          default:
            return Data(parentData.url, parse(result));
        }
      } catch (e) {
        printLog("HTTP Parser Result Error: $e", debug, color: LogColor.red);
      }
    } else {
      return Data(parentData.url, result);
    }
  }
  printLog("HTTP Parser: No data found!", debug, color: LogColor.red);
  return null;
}
