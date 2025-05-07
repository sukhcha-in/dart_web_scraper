import 'package:http_client/http_client.dart' as base;
import 'package:http_client/browser.dart' as browser;
import '../enums.dart';

base.Client createHttpClient({
  HttpClientType clientType = HttpClientType.browserClient,
  Map<String, String>? headers,
  String? userAgent,
  String? socksProxy,
  dynamic socksProxyType,
  String? proxy,
  String Function(Uri uri)? proxyFn,
  Duration? idleTimeout,
  int? maxConnectionsPerHost,
  bool? autoUncompress,
  bool? ignoreBadCertificates,
}) {
  switch (clientType) {
    case HttpClientType.browserClient:
      return browser.BrowserClient();
    default:
      throw UnsupportedError('Only BrowserClient is supported in the browser.');
  }
}
