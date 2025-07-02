import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';

/// Extracts sibling elements based on CSS selectors and direction
/// Returns Data object with sibling HTML or null if not found
Data? siblingParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Sibling", debug, color: LogColor.cyan);

  // Get parent element(s) to search within
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Sibling Parser: Element not found!",
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

  // Handle dynamic selector with slot injection
  String selector;
  if (parser.selectors.first.contains("<slot>")) {
    selector = inject("slot", allData, parser.selectors.first);
    printLog(
      "Sibling Selector Modified: $selector",
      debug,
      color: LogColor.green,
    );
  } else {
    selector = parser.selectors.first;
  }

  // Find all matching elements
  List<Element> elements = document.querySelectorAll(selector);
  if (selector.isNotEmpty) {
    for (final element in elements) {
      if (parser.parserOptions?.sibling != null) {
        // Use custom sibling options
        Element? sib;
        if (parser.parserOptions!.sibling!.direction ==
            SiblingDirection.previous) {
          sib = element.previousElementSibling;
        } else {
          sib = element.nextElementSibling;
        }

        // Check if element text contains specified keywords
        if (parser.parserOptions!.sibling!.where != null) {
          List<String> where = parser.parserOptions!.sibling!.where!;
          String selectorText = element.text.toString().trim();
          for (final w in where) {
            if (selectorText.contains(w)) {
              if (sib != null) {
                return Data(parentData.url, sib.outerHtml);
              }
            }
          }
        }

        // Return sibling if found
        if (sib != null) {
          return Data(parentData.url, sib.outerHtml);
        }
      } else {
        // Default behavior: return next sibling
        Element? sib = element.nextElementSibling;
        if (sib != null) {
          return Data(parentData.url, sib.outerHtml);
        }
      }
    }
  }

  printLog(
    "Sibling Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}
