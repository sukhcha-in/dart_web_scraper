import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Configuration options for HTTP parser behavior.
///
/// This class contains all the configuration needed to make HTTP requests
/// during data extraction, such as URL, method, headers, payload, etc.
class HttpParserOptions {
  /// The target URL for the HTTP request.
  ///
  /// This is the endpoint that will be called when making the HTTP request.
  /// If null, the request will use parents extracted data as the URL.
  final String? url;

  /// The HTTP method to use for the request (GET, POST, PUT, etc.).
  ///
  /// Common values include HttpMethod.get, HttpMethod.post, HttpMethod.put, etc.
  /// If null, defaults to GET method.
  final HttpMethod? method;

  /// Custom HTTP headers to include in the request.
  ///
  /// These headers will be sent along with the HTTP request.
  /// Useful for authentication, content-type specification, or custom headers.
  /// Example: {'Authorization': 'Bearer token', 'Content-Type': 'application/json'}
  final Map<String, String>? headers;

  /// Cookies to include in the request.
  ///
  /// These cookies will be sent along with the HTTP request.
  /// Useful for authentication, session management, or custom cookies.
  /// Example: {'foo': 'bar', 'baz': 'qux'}
  final Map<String, String>? cookies;

  /// The user agent device type to simulate.
  ///
  /// This determines which user agent string will be used for the request.
  /// Useful for mimicking different browsers or devices.
  /// If null, uses the default user agent.
  final UserAgentDevice? userAgent;

  /// The expected response type from the HTTP request.
  ///
  /// Determines how the response should be parsed and handled.
  /// Common types include HttpResponseType.text, HttpResponseType.json, etc.
  final HttpResponseType? responseType;

  /// The payload/data to send with the request.
  ///
  /// This is the body content for POST, PUT, or other methods that require data.
  /// Can be a string, Map, or any serializable object.
  final Object? payload;

  /// The type of payload being sent.
  ///
  /// Specifies the format of the payload (e.g., HttpPayload.json, HttpPayload.form).
  /// This helps determine how the payload should be serialized.
  final HttpPayload? payloadType;

  /// Proxy API configuration.
  ///
  /// This configuration is used to proxy the HTTP request through a proxy API.
  /// Useful for bypassing IP bans or accessing content that is blocked in certain regions.
  final ProxyAPIConfig? proxyAPIConfig;

  /// Creates a new HttpParserOptions instance.
  ///
  /// All parameters are optional and have sensible defaults.
  ///
  /// [url] - The target URL for the request
  /// [method] - The HTTP method to use
  /// [headers] - Custom headers to include
  /// [cookies] - Cookies to include
  /// [userAgent] - User agent device to simulate
  /// [responseType] - Expected response type
  /// [payload] - Data to send with the request
  /// [payloadType] - Format of the payload
  /// [proxyAPIConfig] - Proxy API configuration
  HttpParserOptions({
    this.url,
    this.method,
    this.headers,
    this.cookies,
    this.userAgent,
    this.responseType,
    this.payload,
    this.payloadType,
    this.proxyAPIConfig,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'method': method?.toString().split('.').last,
      'headers': headers,
      'cookies': cookies,
      'userAgent': userAgent?.toString().split('.').last,
      'responseType': responseType?.toString().split('.').last,
      'payload': payload,
      'payloadType': payloadType?.toString().split('.').last,
      'proxyAPIConfig': proxyAPIConfig?.toMap(),
    };
  }

  factory HttpParserOptions.fromMap(Map<String, dynamic> map) {
    return HttpParserOptions(
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
      responseType: map['responseType'] != null
          ? HttpResponseType.values.firstWhere(
              (e) => e.toString() == 'HttpResponseType.${map['responseType']}',
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
    );
  }

  String toJson() => json.encode(toMap());

  factory HttpParserOptions.fromJson(String source) =>
      HttpParserOptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
