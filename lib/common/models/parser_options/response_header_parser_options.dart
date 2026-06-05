import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Configuration options for the responseHeaders parser.
///
/// The responseHeaders parser sends an HTTP request and extracts a value from
/// the response headers (for example, pulling a cookie out of the `set-cookie`
/// header). The request portion mirrors a subset of [HttpParserOptions];
/// [headerName]/[cookieName] control what is extracted from the response.
class ResponseHeaderParserOptions {
  /// The target URL for the request.
  ///
  /// If null, the request uses the parent parser's extracted URL.
  /// Supports `slot` injection from previously extracted data.
  final String? url;

  /// The HTTP method to use for the request.
  ///
  /// Supports [HttpMethod.get] and [HttpMethod.post]. Defaults to GET.
  final HttpMethod? method;

  /// Custom HTTP request headers to send.
  ///
  /// Values support `slot` injection from previously extracted data.
  final Map<String, String>? headers;

  /// Cookies to send with the request.
  ///
  /// Serialized into the `Cookie` request header.
  final Map<String, String>? cookies;

  /// The user agent device type to simulate for the request.
  ///
  /// If null, a random user agent is used.
  final UserAgentDevice? userAgent;

  /// The payload/body to send with a POST request.
  ///
  /// Can be a string or a serializable object. Supports `slot` injection from
  /// previously extracted data. Ignored for GET requests.
  final Object? payload;

  /// The format of the [payload].
  ///
  /// [HttpPayload.json] encodes the payload as JSON; otherwise it is sent as a
  /// plain string. Defaults to string.
  final HttpPayload? payloadType;

  /// Proxy API configuration for routing the request through a proxy.
  final ProxyAPIConfig? proxyAPIConfig;

  /// The response header to extract (case-insensitive), e.g. `set-cookie`.
  ///
  /// If null, the parser returns the full response headers as a `Map`.
  final String? headerName;

  /// Optional cookie name to extract from the [headerName] value.
  ///
  /// When set, the header value is treated as a `set-cookie`-style string and
  /// only this cookie's value is returned. Has no effect when [headerName] is
  /// null.
  final String? cookieName;

  /// Creates a new ResponseHeaderParserOptions instance.
  ///
  /// [url] - Target URL (defaults to the parent URL)
  /// [method] - HTTP method (GET or POST, defaults to GET)
  /// [headers] - Custom request headers
  /// [cookies] - Cookies to send with the request
  /// [userAgent] - User agent device to simulate
  /// [payload] - Body to send with a POST request
  /// [payloadType] - Format of the payload (json or string)
  /// [proxyAPIConfig] - Proxy API configuration
  /// [headerName] - Response header to extract (null returns all headers)
  /// [cookieName] - Cookie to extract from the header value
  ResponseHeaderParserOptions({
    this.url,
    this.method,
    this.headers,
    this.cookies,
    this.userAgent,
    this.payload,
    this.payloadType,
    this.proxyAPIConfig,
    this.headerName,
    this.cookieName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'method': method?.toString().split('.').last,
      'headers': headers,
      'cookies': cookies,
      'userAgent': userAgent?.toString().split('.').last,
      'payload': payload,
      'payloadType': payloadType?.toString().split('.').last,
      'proxyAPIConfig': proxyAPIConfig?.toMap(),
      'headerName': headerName,
      'cookieName': cookieName,
    };
  }

  factory ResponseHeaderParserOptions.fromMap(Map<String, dynamic> map) {
    return ResponseHeaderParserOptions(
      url: map['url'] as String?,
      method: map['method'] != null
          ? HttpMethod.values.firstWhere(
              (e) => e.toString() == 'HttpMethod.${map['method']}',
            )
          : null,
      headers: map['headers'] != null
          ? Map<String, String>.from(map['headers'] as Map)
          : null,
      cookies: map['cookies'] != null
          ? Map<String, String>.from(map['cookies'] as Map)
          : null,
      userAgent: map['userAgent'] != null
          ? UserAgentDevice.values.firstWhere(
              (e) => e.toString() == 'UserAgentDevice.${map['userAgent']}',
            )
          : null,
      payload: map['payload'],
      payloadType: map['payloadType'] != null
          ? HttpPayload.values.firstWhere(
              (e) => e.toString() == 'HttpPayload.${map['payloadType']}',
            )
          : null,
      proxyAPIConfig: map['proxyAPIConfig'] != null
          ? ProxyAPIConfig.fromMap(map['proxyAPIConfig'])
          : null,
      headerName: map['headerName'] as String?,
      cookieName: map['cookieName'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseHeaderParserOptions.fromJson(String source) =>
      ResponseHeaderParserOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
