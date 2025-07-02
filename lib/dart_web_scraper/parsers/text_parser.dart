import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Extracts text content from HTML elements
/// Returns Data object with text content or null if not found
Data? textParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Text", debug, color: LogColor.cyan);

  // Get parent element(s) to search within
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Text Parser: Element not found!",
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

  // Try each selector until text is found
  for (final sel in parser.selectors) {
    if (sel == '_self') {
      return Data(parentData.url, document.text);
    }
    printLog("Text Selector: $sel", debug, color: LogColor.cyan);
    String selector;

    // Handle dynamic selectors with slot injection
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "Text Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }

    // Extract text using the handler
    Object? data = textHandler(parser, document, selectr: selector);
    if (data != null && data != [] && data != "") {
      return Data(parentData.url, data);
    }
  }

  printLog(
    "Text Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}

/// Handles text extraction for single or multiple elements
/// Handles special cases like <br> tags in HTML content
Object? textHandler(Parser parser, Element source, {required String selectr}) {
  List<String> results = [];
  if (parser.multiple) {
    // Extract text from all matching elements
    List<Element> selector = source.querySelectorAll(selectr);
    if (selector.isNotEmpty) {
      for (final s in selector) {
        // Handle <br> tags by replacing them with spaces
        if (s.innerHtml.contains("<br>")) {
          String outerHtml = s.outerHtml.replaceAll("<br>", " ");
          Document outerDom = parse(outerHtml);
          results.add(outerDom.body!.text.toString().trim());
        } else {
          results.add(s.text.toString().trim());
        }
      }
      // Remove empty results
      results.removeWhere((value) => value == "");
      return results;
    }
  } else {
    // Extract text from single element
    Element? selector = source.querySelector(selectr);
    if (selector != null) {
      if (selector.text.toString().trim() != "") {
        return selector.text.toString().trim();
      }
    }
  }
  return null;
}
