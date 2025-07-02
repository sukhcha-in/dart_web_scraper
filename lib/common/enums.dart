/// Used for Http Parser
enum HttpResponseType { json, html, text }

/// Set User Agent for HTTP Request
enum UserAgentDevice { mobile, desktop }

/// Parser Types
enum ParserType {
  element,
  attribute,
  text,
  image,
  url,
  urlParam,
  table,
  sibling,
  strBetween,
  http,
  json,
  jsonld,
  jsonTable,
  json5decode,
  staticVal,
  returnUrlParser,
}

/// HTTP Methods for HttpParser
enum HttpMethod { get, post }

/// Payload Type for HttpParser
enum HttpPayload { string, json }

/// Sibling Direction for ParserType.sibling
enum SiblingDirection { previous, next }

/// Log Colors for Logger
enum LogColor {
  reset,
  black,
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  white,
  orange
}
