import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Extracts image src URLs from HTML img elements
/// Returns Data object with image URL or null if not found
Data? imageParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Image", debug, color: LogColor.cyan);

  // Get parent element(s) to search within
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Image Parser: Element not found!",
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

  // Try each selector until image is found
  for (final sel in parser.selectors) {
    printLog("Image Selector: $sel", debug, color: LogColor.cyan);
    String selector;

    // Handle dynamic selectors with slot injection
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "Image Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }

    // Extract image using the handler
    Object? data = imgHandler(parser, document, selectr: selector);
    if (data != null && data != [] && data != "") {
      return Data(parentData.url, data);
    }
  }

  printLog(
    "Image Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}

/// Handles image extraction by finding img element and extracting src attribute
/// Returns image URL string or null if not found
Object? imgHandler(Parser parser, Element source, {required String selectr}) {
  Element? selector = source.querySelector(selectr);
  if (selector != null) {
    String? src = selector.attributes['src'];
    if (src != null) {
      return src.toString();
    }
  }
  return null;
}
