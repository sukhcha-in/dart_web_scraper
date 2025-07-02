import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Extracts key-value pairs from HTML table structures
/// Returns Data object with Map of key-value pairs or null if not found
Data? tableParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Table", debug, color: LogColor.cyan);

  // Get parent element(s) to search within
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Table Parser: Element not found!",
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

  // Try each selector until table data is found
  for (final sel in parser.selectors) {
    printLog("Table Selector: $sel", debug, color: LogColor.cyan);
    String selector;

    // Handle dynamic selectors with slot injection
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "Table Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }

    // Find all matching table elements
    List<Element> elements = document.querySelectorAll(selector);
    if (elements.isEmpty) {
      continue;
    }

    // Extract key-value pairs from table elements
    Map<String, String> result = {};
    if (elements.isNotEmpty) {
      for (final element in elements) {
        if (parser.parserOptions?.table?.keys != null) {
          // Use custom key and value selectors
          Element? keySelector =
              element.querySelector(parser.parserOptions!.table!.keys);
          String? key = keySelector?.text;
          String? value;
          if (parser.parserOptions?.table?.values != null) {
            value = element
                .querySelector(parser.parserOptions!.table!.values!)
                ?.text;
          } else {
            value = keySelector?.nextElementSibling?.text;
          }
          if (key != null && value != null) {
            // Remove non-ASCII characters from value
            value = value.replaceAll(RegExp('[^\x00-\x7F]+'), '');
            if (key.trim() != "" && value.trim() != "") {
              result.addAll({key.trim(): value.trim()});
            }
          }
        } else {
          // Use default behavior: current element as key, next sibling as value
          if (element.text.trim() != "" &&
              element.nextElementSibling!.text.trim() != "") {
            result.addAll(
                {element.text.trim(): element.nextElementSibling!.text.trim()});
          }
        }
      }
      return Data(parentData.url, result);
    }
  }

  printLog(
    "Table Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}
