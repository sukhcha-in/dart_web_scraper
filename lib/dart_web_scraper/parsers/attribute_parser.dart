import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Parses HTML attributes from DOM elements based on CSS selectors
/// Returns Data object with extracted attribute values or null if not found
Data? attributeParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Attribute", debug, color: LogColor.cyan);

  // Get parent element(s) to search within
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Attribute Parser: Element not found!",
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
    printLog("Attribute Selector: $sel", debug, color: LogColor.cyan);
    String selector;

    // Handle dynamic selectors with slot injection
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "Attribute Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }

    // Split selector into CSS selector and attribute name
    List<String> split = selector.toString().split("::");

    // Extract attribute value using the handler
    Object? data = attrHandler(
      parser,
      document,
      selectr: split[0],
      attr: split[1],
    );

    // Return first non-empty result
    if (data != null && data != "") {
      return Data(parentData.url, data);
    }
  }

  printLog(
    "Attribute Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}

/// Handles attribute extraction for single or multiple elements
/// Returns attribute value(s) or null if not found
Object? attrHandler(
  Parser parser,
  Element source, {
  required String selectr,
  required String attr,
}) {
  // Handle multiple elements mode
  if (parser.multiple) {
    List<Element> selector = source.querySelectorAll(selectr);
    if (selector.isNotEmpty) {
      List<String> result = [];
      // Extract attribute from each matching element
      for (final sel in selector) {
        String? attribute = sel.attributes[attr];
        if (attribute != null) {
          result.add(attribute.toString());
        }
      }
      return result;
    }
  } else {
    // Handle single element mode
    Element? selector = source.querySelector(selectr);

    // Special case: use source element itself
    if (selectr == '_self') {
      selector = source;
    }

    if (selector != null) {
      String? attribute = selector.attributes[attr];
      if (attribute != null) {
        return attribute.toString();
      }
    }
  }
  return null;
}
