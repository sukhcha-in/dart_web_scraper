import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Extracts text between specified start and end strings
/// Returns Data object with extracted text or null if not found
Data? stringBetweenParser({
  required Parser parser,
  required Data parentData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog(
    "ID: ${parser.id} Parser: String Between",
    debug,
    color: LogColor.cyan,
  );

  // Get parent element(s) to search within
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "StringBetween Parser: Element not found!",
      debug,
      color: LogColor.red,
    );
    return null;
  }

  // Handle single element (multiple elements not supported)
  Element document;
  if (element.length == 1) {
    document = element[0];
  } else {
    throw UnimplementedError("Multiple elements not supported");
  }

  // Get HTML content to search within
  String source = document.outerHtml;

  // Extract text between start and end markers
  String tmp;
  String start = parser.parserOptions?.stringBetween?.start ?? "";
  String end = parser.parserOptions?.stringBetween?.end ?? "";

  // Find start marker position
  final startIndex = source.indexOf(start);
  if (startIndex == -1) {
    printLog(
      "StringBetween Parser: No data found!",
      debug,
      color: LogColor.orange,
    );
    return null;
  }

  // Find end marker position after start marker
  final endIndex = source.indexOf(end, startIndex + start.length);
  try {
    // Extract substring between markers
    tmp = source.substring(startIndex + start.length, endIndex);
  } catch (e) {
    printLog(
      "StringBetween Parser: No data found!",
      debug,
      color: LogColor.orange,
    );
    return null;
  }
  return Data(parentData.url, tmp.trim());
}
