import 'dart:convert';
import 'dart:io';
import 'package:dart_web_scraper/common/utils/http.dart';
import 'package:dart_web_scraper/common/utils/random.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/parser.dart';

Future<Data?> httpParser(
  Parser parser,
  Data parentData,
  Map<String, Object> allData,
  Uri? proxyUrl,
  bool debug,
) async {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: HTTP", debug, color: LogColor.cyan);
  String url;
  HttpMethod method = HttpMethod.get;
  Object? payLoad;
  HttpPayload payloadType = HttpPayload.string;
  Map<String, String> headers = {};
  //Set from optional
  if (parser.optional != null) {
    if (parser.optional!.url != null) {
      url = parser.optional!.url!;
    } else {
      url = parentData.url.toString();
    }
    if (parser.optional!.method != null) {
      method = parser.optional!.method!;
    }
    printLog("HTTP Parser URL: $url", debug, color: LogColor.magenta);
    printLog("HTTP Parser method: $method", debug, color: LogColor.magenta);

    //Set cookie headers
    if (parser.optional!.headers != null) {
      parser.optional!.headers!.forEach((k, v) {
        headers.addAll({k.toString(): v.toString()});
      });
    }

    if (!headers.containsKey("user-agent") &&
        parser.optional!.userAgent != null) {
      headers.addAll({
        HttpHeaders.userAgentHeader:
            randomUserAgent(parser.optional!.userAgent!),
      });
    }

    //Inject data to headers
    String encodedHeaders = jsonEncode(headers);
    encodedHeaders = inject("slot", allData, encodedHeaders);
    Object decodedHeaders = jsonDecode(encodedHeaders);
    decodedHeaders = decodedHeaders as Map;
    decodedHeaders.forEach((key, value) {
      headers.addAll({key: value.toString()});
    });

    //Set default payloadType
    if (parser.optional!.payloadType != null) {
      payloadType = parser.optional!.payloadType!;
    }

    //Inject data to payLoad
    if (parser.optional!.payLoad != null) {
      payLoad = parser.optional!.payLoad!;
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

  //If url contains slot
  url = inject("slot", allData, url);

  printLog(
    "HTTP Parser URL after injection: $url",
    debug,
    color: LogColor.magenta,
  );
  printLog("HTTP Parser Headers: $headers", debug, color: LogColor.magenta);
  printLog("HTTP Parser Payload: $payLoad", debug, color: LogColor.magenta);

  //Declare empty result
  Object? result;
  if (method == HttpMethod.get) {
    result = await getRequest(
      Uri.parse(url),
      headers: headers,
      debug: debug,
      proxyUrl: parser.optional!.usePassedProxy ? proxyUrl : null,
      cacheResponse: parser.optional!.cacheResponse,
    );
  } else if (method == HttpMethod.post) {
    result = await postRequest(
      Uri.parse(url),
      headers: headers,
      body: payLoad,
      debug: debug,
      proxyUrl: parser.optional!.usePassedProxy ? proxyUrl : null,
      cacheResponse: parser.optional!.cacheResponse,
    );
  } else {
    printLog("HTTP Parser: Invalid method!", debug, color: LogColor.red);
    return null;
  }

  //If result is there
  if (result != null && result.toString().trim() != "") {
    if (parser.optional != null && parser.optional!.responseType != null) {
      try {
        switch (parser.optional!.responseType!) {
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
