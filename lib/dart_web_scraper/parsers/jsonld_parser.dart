import 'dart:convert';
import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? jsonLdParser(
  Parser parser,
  Data parentData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: JSON+LD", debug, color: LogColor.cyan);
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "JSON+LD Parser: Element not found!",
      debug,
      color: LogColor.red,
    );
    return null;
  }
  Element document;
  if (element.length == 1) {
    document = element[0];
  } else {
    throw UnimplementedError("Multiple elements not supported");
  }

  List results = [];
  List<Element> selector =
      document.querySelectorAll('script[type="application/ld+json"]');
  if (selector.isNotEmpty) {
    for (final s in selector) {
      String innerHtml = s.innerHtml.replaceAll("\n", "");
      innerHtml = innerHtml.replaceAll("\t", "");
      Object json = jsonDecode(innerHtml);
      if (json is Map) {
        if (json["@graph"] != null) {
          results.addAll(json["@graph"]);
        } else {
          results.add(json);
        }
      } else if (json is Iterable) {
        results.addAll(json);
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
