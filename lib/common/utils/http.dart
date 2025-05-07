import 'dart:convert';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:http_client/curl.dart';
import 'package:http_client/http_client.dart' as base;
import 'package:dart_web_scraper/common/utils/client_factory.dart';

/// GET request to fetch data from URL using selected client type
class ConsoleClientOptions {
  final String? proxy;
  final String Function(Uri uri)? proxyFn;
  final Duration? idleTimeout;
  final int? maxConnectionsPerHost;
  final bool? autoUncompress;
  final bool? ignoreBadCertificates;

  const ConsoleClientOptions({
    this.proxy,
    this.proxyFn,
    this.idleTimeout,
    this.maxConnectionsPerHost,
    this.autoUncompress,
    this.ignoreBadCertificates,
  });
}

class CurlClientOptions {
  final String? socksProxy;
  final CurlSocksProxyType socksProxyType;

  const CurlClientOptions({
    this.socksProxy,
    this.socksProxyType = CurlSocksProxyType.socks5,
  });
}

Future<String?> getRequest(
  Uri url, {
  Map<String, String> headers = const {},
  bool debug = false,
  Uri? proxyAPI,
  String? proxyUrlParam,
  bool cacheResponse = false,
  String? userAgent,
  ConsoleClientOptions consoleClientOptions = const ConsoleClientOptions(),
  CurlClientOptions curlClientOptions = const CurlClientOptions(),
  HttpClientType clientType = HttpClientType.browserClient,
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

  base.Client? client;
  try {
    client = createHttpClient(
      clientType: clientType,
      headers: headers,
      userAgent: userAgent,
      socksProxy: curlClientOptions.socksProxy,
      socksProxyType: curlClientOptions.socksProxyType,
      proxy: consoleClientOptions.proxy,
      proxyFn: consoleClientOptions.proxyFn,
      idleTimeout: consoleClientOptions.idleTimeout,
      maxConnectionsPerHost: consoleClientOptions.maxConnectionsPerHost,
      autoUncompress: consoleClientOptions.autoUncompress,
      ignoreBadCertificates: consoleClientOptions.ignoreBadCertificates,
    );

    final request = base.Request('GET', url, headers: headers);

    final response = await client.send(request);
    final bodyBytes = await response.readAsBytes();
    final body = utf8.decode(bodyBytes);

    printLog(
      "HTTP Response: ${response.statusCode}",
      debug,
      color: LogColor.yellow,
    );
    printLog(
      "HTTP Response body.length ${body.length}",
      debug,
      color: LogColor.yellow,
    );
    printLog(
      "HTTP Response headers ${response.headers.toSimpleMap()}",
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
  } finally {
    await client?.close();
  }
}

/// POST request to fetch data from URL using selected client type
Future<String?> postRequest(
  Uri url, {
  Object? body,
  Map<String, String> headers = const {},
  bool debug = false,
  Uri? proxyAPI,
  String? proxyUrlParam,
  String? userAgent,
  ConsoleClientOptions consoleClientOptions = const ConsoleClientOptions(),
  CurlClientOptions curlClientOptions = const CurlClientOptions(),
  HttpClientType clientType = HttpClientType.browserClient,
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

  base.Client? client;
  try {
    client = createHttpClient(
      clientType: clientType,
      headers: headers,
      userAgent: userAgent,
      socksProxy: curlClientOptions.socksProxy,
      socksProxyType: curlClientOptions.socksProxyType,
      proxy: consoleClientOptions.proxy,
      proxyFn: consoleClientOptions.proxyFn,
      idleTimeout: consoleClientOptions.idleTimeout,
      maxConnectionsPerHost: consoleClientOptions.maxConnectionsPerHost,
      autoUncompress: consoleClientOptions.autoUncompress,
      ignoreBadCertificates: consoleClientOptions.ignoreBadCertificates,
    );

    dynamic requestBody;
    Map<String, String> requestHeaders = Map.from(headers);

    if (body != null) {
      if (body is String) {
        requestBody = utf8.encode(body);
      } else if (body is List<int>) {
        requestBody = body;
      } else if (body is Map) {
        requestBody = utf8.encode(json.encode(body));
        requestHeaders['Content-Type'] = 'application/json';
      } else {
        throw Exception('Unsupported body type');
      }
    }

    final request =
        base.Request('POST', url, headers: requestHeaders, body: requestBody);

    final response = await client.send(request);
    final bodyBytes = await response.readAsBytes();
    return utf8.decode(bodyBytes);
  } catch (e) {
    printLog(e.toString(), debug, color: LogColor.red);
    return null;
  } finally {
    await client?.close();
  }
}
