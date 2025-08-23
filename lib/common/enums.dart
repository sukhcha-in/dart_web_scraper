/// Types of HTTP responses that can be processed by HTTP parsers.
///
/// Determines how the response from an HTTP request should be interpreted:
/// - [json] - Parse response as JSON data
/// - [html] - Parse response as HTML document
/// - [text] - Treat response as plain text
enum HttpResponseType {
  /// Parse response as JSON data structure
  json,

  /// Parse response as HTML document for further parsing
  html,

  /// Treat response as plain text without parsing
  text
}

/// Device types for user agent strings in HTTP requests.
///
/// Different user agents can affect how websites respond to requests:
/// - [mobile] - Mobile device user agent (default)
/// - [desktop] - Desktop browser user agent
enum UserAgentDevice {
  /// Mobile device user agent string
  mobile,

  /// Desktop browser user agent string
  desktop,

  /// Random user agent string
  random,

  /// Android device user agent string
  android,

  /// iOS device user agent string
  ios,

  /// Windows device user agent string
  windows,

  /// Linux device user agent string
  linux,

  /// Mac device user agent string
  mac,
}

/// Types of parsers available for data extraction.
///
/// Each parser type has specialized logic for extracting different kinds
/// of data from HTML, JSON, or other sources:
/// - [element] - Extract HTML elements
/// - [attribute] - Extract attribute values from HTML elements
/// - [text] - Extract text content from HTML elements
/// - [image] - Extract image URLs and metadata
/// - [url] - Extract and process URLs
/// - [urlParam] - Extract URL parameters
/// - [table] - Extract data from HTML tables
/// - [sibling] - Extract sibling elements
/// - [strBetween] - Extract text between two strings
/// - [http] - Make HTTP requests to extract data
/// - [json] - Extract and parse JSON data
/// - [jsonld] - Extract JSON-LD structured data
/// - [jsonTable] - Extract data from JSON table structures
/// - [json5decode] - Parse JSON5 format data
/// - [staticVal] - Return static values
/// - [returnUrlParser] - Return URL-based data
/// - [empty] - Return empty value, helpful for using parent data as a fallback
enum ParserType {
  /// Extract HTML elements for further processing
  element,

  /// Extract parent element of HTML elements
  parentElement,

  /// Extract attribute values (href, src, class, etc.) from HTML elements
  attribute,

  /// Extract text content from HTML elements
  text,

  /// Extract image URLs, alt text, and other image metadata
  image,

  /// Extract and process URLs (absolute, relative, etc.)
  url,

  /// Extract specific URL parameters
  urlParam,

  /// Extract structured data from HTML tables
  table,

  /// Extract sibling elements (previous or next)
  sibling,

  /// Extract text between two specified strings
  strBetween,

  /// Make HTTP requests to extract data from other URLs
  http,

  /// Extract and parse JSON data from HTML or other sources
  json,

  /// Extract JSON-LD structured data from HTML
  jsonld,

  /// Extract data from JSON table structures
  jsonTable,

  /// Parse JSON5 format data (JSON with comments and trailing commas)
  json5decode,

  /// Return static values without extraction
  staticVal,

  /// Return URL-based data without making requests
  returnUrlParser,

  /// Return empty value, helpful for using parent data as a fallback
  empty,
}

/// HTTP methods for making requests in HTTP parsers.
///
/// Defines the type of HTTP request to make:
/// - [get] - GET request (default for retrieving data)
/// - [post] - POST request (for sending data)
enum HttpMethod {
  /// GET request method for retrieving data
  get,

  /// POST request method for sending data
  post
}

/// Types of payload data for HTTP requests.
///
/// Determines how request data should be formatted:
/// - [string] - Send data as plain text
/// - [json] - Send data as JSON format
enum HttpPayload {
  /// Send request data as plain text
  string,

  /// Send data as JSON format
  json
}

/// Directions for sibling element extraction.
///
/// Defines which sibling element to extract relative to the current element:
/// - [previous] - Extract the previous sibling element
/// - [next] - Extract the next sibling element
enum SiblingDirection {
  /// Extract the previous sibling element
  previous,

  /// Extract the next sibling element
  next
}

/// Colors for debug logging output.
///
/// Provides color coding for different types of log messages to improve
/// readability during debugging:
/// - [reset] - Reset color to default
/// - [black] - Black text
/// - [red] - Red text (typically for errors)
/// - [green] - Green text (typically for success)
/// - [yellow] - Yellow text (typically for warnings)
/// - [blue] - Blue text (typically for info)
/// - [magenta] - Magenta text
/// - [cyan] - Cyan text
/// - [white] - White text
/// - [orange] - Orange text (typically for highlights)
enum LogColor {
  /// Reset color to terminal default
  reset,

  /// Black text color
  black,

  /// Red text color (typically for errors)
  red,

  /// Green text color (typically for success)
  green,

  /// Yellow text color (typically for warnings)
  yellow,

  /// Blue text color (typically for info)
  blue,

  /// Magenta text color
  magenta,

  /// Cyan text color
  cyan,

  /// White text color
  white,

  /// Orange text color (typically for highlights)
  orange
}
