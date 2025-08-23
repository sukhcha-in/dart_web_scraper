import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Parses HTML elements using CSS selectors
/// Returns Data object with extracted parent element or null if not found
Data? parentElementParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Parent Element", debug,
      color: LogColor.cyan);

  // Get element from parent data
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Parent Element Parser: Element not found!",
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

  // Try each selector until data is found
  for (final sel in parser.selectors) {
    if (sel == '_self') {
      throw UnimplementedError(
        "Cannot use _self selector with parent element parser",
      );
    }
    printLog("Parent Element Selector: $sel", debug, color: LogColor.cyan);

    // Handle dynamic selectors with slot injection
    String selector;
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "Parent Element Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }

    // Extract parent element using selector
    Element? qs = document.querySelector(selector);
    if (qs?.parent != null) {
      return Data(parentData.url, qs!.parent!);
    }
    return null;
  }

  printLog(
    "Parent Element Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}
