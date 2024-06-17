import 'dart:convert';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:http/http.dart' as http;

/// GET request to fetch data from URL
Future<String?> getRequest(
  Uri url, {
  Map<String, String> headers = const {},
  bool headless = false,
  bool debug = false,
  Uri? proxyUrl,
  bool cacheResponse = true,
}) async {
  printLog("HTTP GET: $url", debug, color: LogColor.yellow);
  if (proxyUrl != null) {
    printLog("Prepending proxy URL...", debug, color: LogColor.yellow);
    url = Uri.parse(proxyUrl.toString() + Uri.encodeComponent(url.toString()));
  }
  printLog("GET URL: $url", debug, color: LogColor.yellow);
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
  Uri? proxyUrl,
  bool? cacheResponse,
}) async {
  if (proxyUrl != null) {
    throw UnimplementedError("Proxy URL not supported for POST requests.");
  }
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
