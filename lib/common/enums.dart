/// Apply methods using Optional
enum ApplyMethod { urldecode, mapToList }

/// Used for Http Parser
enum HttpResponseType { json, html, text }

/// Set User Agent for HTTP Request
enum UserAgentDevice { mobile, desktop }

/// Parser Types
enum ParserType {
  element,
  text,
  image,
  attribute,
  json,
  url,
  http,
  strBetween,
  jsonld,
  table,
  sibling,
  urlParam,
  jsonTable,
  staticVal,
  json5decode,
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
