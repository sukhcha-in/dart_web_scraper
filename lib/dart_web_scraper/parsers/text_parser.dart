import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? textParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Text", debug, color: LogColor.cyan);
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Text Parser: Element not found!",
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

  for (final sel in parser.selector) {
    printLog("Text Selector: $sel", debug, color: LogColor.cyan);
    String selector;
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

Object? textHandler(Parser parser, Element source, {required String selectr}) {
  List<String> results = [];
  if (parser.multiple) {
    List<Element> selector = source.querySelectorAll(selectr);
    if (selector.isNotEmpty) {
      for (final s in selector) {
        if (s.innerHtml.contains("<br>")) {
          String outerHtml = s.outerHtml.replaceAll("<br>", " ");
          Document outerDom = parse(outerHtml);
          results.add(outerDom.body!.text.toString().trim());
        } else {
          results.add(s.text.toString().trim());
        }
      }
      results.removeWhere((value) => value == "");
      return results;
    }
  } else {
    Element? selector = source.querySelector(selectr);
    if (selector != null) {
      if (selector.text.toString().trim() != "") {
        return selector.text.toString().trim();
      }
    }
  }
  return null;
}
