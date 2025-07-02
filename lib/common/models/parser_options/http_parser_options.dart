import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Configuration options for HTTP parser behavior.
///
/// This class contains all the configuration needed to make HTTP requests
/// during data extraction, such as URL, method, headers, payload, etc.
class HttpParserOptions {
  final String? url;
  final HttpMethod? method;
  final Map<String, Object>? headers;
  final UserAgentDevice? userAgent;
  final HttpResponseType? responseType;
  final Object? payload;
  final HttpPayload? payloadType;
  final bool useProxy;
  final bool dumpResponse;

  HttpParserOptions({
    this.url,
    this.method,
    this.headers,
    this.userAgent,
    this.responseType,
    this.payload,
    this.payloadType,
    this.useProxy = false,
    this.dumpResponse = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'method': method?.toString().split('.').last,
      'headers': headers,
      'userAgent': userAgent?.toString().split('.').last,
      'responseType': responseType?.toString().split('.').last,
      'payload': payload,
      'payloadType': payloadType?.toString().split('.').last,
      'useProxy': useProxy,
      'dumpResponse': dumpResponse,
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
          ? Map<String, Object>.from(map['headers'] as Map)
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
      useProxy: map['useProxy'] as bool,
      dumpResponse: map['dumpResponse'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory HttpParserOptions.fromJson(String source) =>
      HttpParserOptions.fromMap(json.decode(source) as Map<String, dynamic>);
}
