import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';

Data? siblingParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Sibling", debug, color: LogColor.cyan);
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Sibling Parser: Element not found!",
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

  String selector;
  if (parser.selector.first.contains("<slot>")) {
    selector = inject("slot", allData, parser.selector.first);
    printLog(
      "Sibling Selector Modified: $selector",
      debug,
      color: LogColor.green,
    );
  } else {
    selector = parser.selector.first;
  }
  List<Element> elements = document.querySelectorAll(selector);
  if (selector.isNotEmpty) {
    for (final element in elements) {
      if (parser.optional != null) {
        Element? sib;
        if (parser.optional!.siblingDirection == SiblingDirection.previous) {
          sib = element.previousElementSibling;
        } else {
          sib = element.nextElementSibling;
        }
        if (parser.optional!.where != null) {
          List<String> where = parser.optional!.where!;
          String selectorText = element.text.toString().trim();
          for (final w in where) {
            if (selectorText.contains(w)) {
              if (sib != null) {
                return Data(parentData.url, sib.outerHtml);
              }
            }
          }
        }
        if (sib != null) {
          return Data(parentData.url, sib.outerHtml);
        }
      } else {
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
