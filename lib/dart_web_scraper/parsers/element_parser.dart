import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Parses HTML elements using CSS selectors
/// Returns Data object with extracted element or null if not found
Data? elementParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Element", debug, color: LogColor.cyan);

  // Get element from parent data
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Element Parser: Element not found!",
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
      return Data(parentData.url, document);
    }
    printLog("Element Selector: $sel", debug, color: LogColor.cyan);

    // Handle dynamic selectors with slot injection
    String selector;
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "Element Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }

    // Extract element using selector
    Object? data = elemHandler(parser, document, selector: selector);
    if (data != null && data != [] && data != "") {
      return Data(parentData.url, data);
    }
  }

  printLog(
    "Element Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}

/// Handles element selection based on parser configuration
/// Returns single element or list of elements based on 'multiple' flag
Object? elemHandler(
  Parser parser,
  Element parentData, {
  required String selector,
}) {
  if (parser.multiple) {
    // Return all matching elements
    List<Element> qs = parentData.querySelectorAll(selector);
    if (qs.isNotEmpty) {
      return qs;
    }
  } else {
    // Return first matching element
    Element? qs = parentData.querySelector(selector);
    if (qs != null) {
      return qs;
    }
  }
  return null;
}
