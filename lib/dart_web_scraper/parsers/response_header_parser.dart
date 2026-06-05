import 'dart:convert';
import 'package:dart_web_scraper/common/utils/cookie_utils.dart';
import 'package:dart_web_scraper/common/utils/http.dart';
import 'package:dart_web_scraper/common/utils/random.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Sends an HTTP request and extracts a value from the response headers.
///
/// Typical use is pulling a cookie out of the `set-cookie` header:
/// set [ResponseHeaderParserOptions.headerName] to `set-cookie` and
/// [ResponseHeaderParserOptions.cookieName] to the cookie you want.
///
/// Supports both GET and POST requests (via
/// [ResponseHeaderParserOptions.method]).
///
/// Behavior:
/// - If `headerName` is null, returns the full response headers as a `Map`.
/// - If `headerName` is set but absent from the response, returns null (so a
///   fallback parser with the same id can run).
/// - If `cookieName` is also set, returns just that cookie's value parsed from
///   the header, or null if not found.
Future<Data?> responseHeaderParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
  required ProxyAPIConfig? overrideProxyAPIConfig,
}) async {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: RESPONSE HEADERS", debug,
      color: LogColor.cyan);

  final ResponseHeaderParserOptions? options =
      parser.parserOptions?.responseHeaders;

  // Resolve target URL (defaults to the parent's URL).
  String url = options?.url ?? parentData.url.toString();

  // Resolve HTTP method (defaults to GET).
  final HttpMethod method = options?.method ?? HttpMethod.get;

  // Build request headers.
  Map<String, String> headers = {};
  if (options?.headers != null) {
    options!.headers!.forEach((k, v) {
      headers[k] = v.toString();
    });
  }

  // Set a user agent if the caller did not provide one.
  if (!headers.containsKey("User-Agent")) {
    headers['User-Agent'] = randomUserAgent(
      options?.userAgent ?? UserAgentDevice.random,
    );
  }

  // Inject dynamic data (slots) into headers from previously extracted data.
  String encodedHeaders = jsonEncode(headers);
  encodedHeaders = inject("slot", allData, encodedHeaders);
  (jsonDecode(encodedHeaders) as Map).forEach((key, value) {
    headers[key] = value.toString();
  });

  // Attach cookies if provided.
  if (options?.cookies != null) {
    headers['Cookie'] = mapToCookie(options!.cookies!);
  }

  // Prepare the POST payload (if any), injecting dynamic data.
  Object? payload;
  if (method == HttpMethod.post && options?.payload != null) {
    payload = options!.payloadType == HttpPayload.json
        ? jsonEncode(options.payload)
        : options.payload.toString();
    payload = inject("slot", allData, payload);
  }

  // Inject dynamic data into the URL.
  url = inject("slot", allData, url);

  printLog("Response Headers Parser URL: $url", debug, color: LogColor.magenta);
  printLog("Response Headers Parser Method: $method", debug,
      color: LogColor.magenta);

  // Fetch the response headers.
  final Map<String, String>? responseHeaders = await getResponseHeaders(
    Uri.parse(url),
    method: method,
    body: payload,
    headers: headers,
    debug: debug,
    proxyAPIConfig: overrideProxyAPIConfig ?? options?.proxyAPIConfig,
  );

  if (responseHeaders == null) {
    printLog("Response Headers Parser: Request failed!", debug,
        color: LogColor.red);
    return null;
  }

  // No specific header requested: return the whole header map.
  final String? headerName = options?.headerName;
  if (headerName == null) {
    return Data(parentData.url, responseHeaders);
  }

  // Header keys are lower-cased by the http client.
  final String? headerValue = responseHeaders[headerName.toLowerCase()];
  if (headerValue == null) {
    printLog(
      "Response Headers Parser: Header '$headerName' not found!",
      debug,
      color: LogColor.red,
    );
    return null;
  }

  // Extract a single cookie from the header value if requested.
  final String? cookieName = options?.cookieName;
  if (cookieName != null) {
    final String? cookieValue = extractCookieFromHeader(headerValue, cookieName);
    if (cookieValue == null) {
      printLog(
        "Response Headers Parser: Cookie '$cookieName' not found in '$headerName'!",
        debug,
        color: LogColor.red,
      );
      return null;
    }
    printLog(
      "Response Headers Parser: Extracted cookie '$cookieName'.",
      debug,
      color: LogColor.green,
    );
    return Data(parentData.url, cookieValue);
  }

  return Data(parentData.url, headerValue);
}
