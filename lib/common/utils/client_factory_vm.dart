import 'package:http_client/http_client.dart' as base;
import 'package:http_client/console.dart' as console;
import 'package:http_client/curl.dart';
import '../enums.dart';

base.Client createHttpClient({
  HttpClientType clientType = HttpClientType.consoleClient,
  Map<String, String>? headers,
  String? userAgent,
  String? socksProxy,
  CurlSocksProxyType socksProxyType = CurlSocksProxyType.socks5,
  String? proxy,
  String Function(Uri uri)? proxyFn,
  Duration? idleTimeout,
  int? maxConnectionsPerHost,
  bool? autoUncompress,
  bool? ignoreBadCertificates,
}) {
  switch (clientType) {
    case HttpClientType.curlClient:
      return CurlClient(
        socksHostPort: socksProxy,
        socksProxyType: socksProxyType,
        userAgent: userAgent,
      );
    case HttpClientType.consoleClient:
      return console.ConsoleClient(
        proxy: proxy,
        proxyFn: proxyFn,
        headers: headers,
        idleTimeout: idleTimeout,
        maxConnectionsPerHost: maxConnectionsPerHost,
        autoUncompress: autoUncompress,
        userAgent: userAgent,
        ignoreBadCertificates: ignoreBadCertificates,
      );
    case HttpClientType.browserClient:
      throw UnsupportedError('BrowserClient is only available in the browser.');
  }
}
