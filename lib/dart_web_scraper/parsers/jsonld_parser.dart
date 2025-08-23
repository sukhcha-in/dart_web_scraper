import 'dart:convert';
import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Extracts JSON-LD structured data from HTML script tags
/// Returns Data object with parsed JSON-LD data or null if not found
Data? jsonLdParser({
  required Parser parser,
  required Data parentData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: JSON+LD", debug, color: LogColor.cyan);

  // Get parent element(s) to search within
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "JSON+LD Parser: Element not found!",
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

  // Find all JSON-LD script tags
  List results = [];
  List<Element> selector =
      document.querySelectorAll('script[type="application/ld+json"]');
  if (selector.isNotEmpty) {
    for (final s in selector) {
      // Clean up JSON string by removing newlines and tabs
      String innerHtml = s.innerHtml.replaceAll("\n", "");
      innerHtml = innerHtml.replaceAll("\t", "");
      try {
        Object json = jsonDecode(innerHtml);

        // Handle different JSON-LD structures
        if (json is Map) {
          if (json["@graph"] != null) {
            // Extract items from @graph array
            results.addAll(json["@graph"]);
          } else {
            // Add single JSON-LD object
            results.add(json);
          }
        } else if (json is Iterable) {
          // Add all items from JSON array
          results.addAll(json);
        }
      } catch (e) {
        printLog(
          "JSON+LD Parser: Error parsing JSON: $e",
          debug,
          color: LogColor.red,
        );
        continue;
      }
    }
    return Data(parentData.url, results);
  }

  printLog(
    "JSON+LD Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}
