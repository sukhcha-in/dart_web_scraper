import 'dart:convert';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:http/http.dart' as http;

/// GET request to fetch data from URL
Future<String?> getRequest(
  Uri url, {
  Map<String, String> headers = const {},
  bool debug = false,
  Uri? proxyAPI,
  String? proxyUrlParam,
  bool cacheResponse = false,
}) async {
  printLog("HTTP GET: $url", debug, color: LogColor.yellow);
  if (proxyAPI != null) {
    printLog("Prepending proxy URL...", debug, color: LogColor.yellow);
    url = proxyAPI.replace(queryParameters: {
      ...proxyAPI.queryParameters,
      proxyUrlParam ?? "url": url.toString(),
    });
  }
  printLog("GET URL: $url", debug, color: LogColor.yellow);
  printLog("GET URL HEADERS: $headers", debug, color: LogColor.yellow);
  try {
    var html = await http
        .get(
          url,
          headers: headers,
        )
        .timeout(
          Duration(seconds: 30),
        );
    String body = utf8.decode(html.bodyBytes);
    printLog(
      "HTTP Response: ${html.statusCode}",
      debug,
      color: LogColor.yellow,
    );
    printLog(
      "HTTP Response body.length ${body.length}",
      debug,
      color: LogColor.yellow,
    );
    printLog(
      "HTTP Response html.headers ${html.headers.toString()}",
      debug,
      color: LogColor.yellow,
    );
    if (cacheResponse) {
      saveCacheLog(body, debug);
    }
    return body;
  } catch (e) {
    printLog(e.toString(), debug, color: LogColor.red);
    return null;
  }
}

/// POST request to fetch data from URL
Future<String?> postRequest(
  Uri url, {
  Object? body,
  Map<String, String> headers = const {},
  bool debug = false,
  Uri? proxyAPI,
  String? proxyUrlParam,
}) async {
  printLog("HTTP POST URL: $url", debug, color: LogColor.magenta);
  if (proxyAPI != null) {
    printLog("Prepending proxy URL...", debug, color: LogColor.yellow);
    url = proxyAPI.replace(queryParameters: {
      ...proxyAPI.queryParameters,
      proxyUrlParam ?? "url": url.toString(),
    });
  }

  printLog("HTTP Parser Headers: $headers", debug, color: LogColor.magenta);
  printLog("HTTP Parser Payload: $body", debug, color: LogColor.magenta);
  try {
    var html = await http
        .post(
          url,
          body: body,
          headers: headers,
        )
        .timeout(
          Duration(seconds: 30),
        );
    return utf8.decode(html.bodyBytes);
  } catch (e) {
    return null;
  }
}
