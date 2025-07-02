import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Extracts href URLs from HTML anchor elements
/// Returns Data object with URL string or null if not found
Data? urlParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: URL", debug, color: LogColor.cyan);

  // Get parent element(s) to search within
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "URL Parser: Element not found!",
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

  // Try each selector until URL is found
  for (final sel in parser.selectors) {
    printLog("URL Parser Selector: $sel", debug, color: LogColor.cyan);
    String selector;

    // Handle dynamic selectors with slot injection
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "URL Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }

    // Find element and extract href attribute
    Element? elm = document.querySelector(selector);
    if (elm != null) {
      String? attribute = elm.attributes['href'];
      if (attribute != null) {
        return Data(parentData.url, attribute.toString());
      }
    }
  }

  printLog(
    "URL Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}
