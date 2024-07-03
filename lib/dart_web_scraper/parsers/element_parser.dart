import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? elementParser(
  Parser parser,
  Data parentData,
  Map<String, Object> allData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Element", debug, color: LogColor.cyan);
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Element Parser: Element not found!",
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
    printLog("Element Selector: $sel", debug, color: LogColor.cyan);
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

Object? elemHandler(
  Parser parser,
  Element parentData, {
  required String selector,
}) {
  if (parser.multiple) {
    List<Element> qs = parentData.querySelectorAll(selector);
    if (qs.isNotEmpty) {
      return qs;
    }
  } else {
    Element? qs = parentData.querySelector(selector);
    if (qs != null) {
      return qs;
    }
  }
  return null;
}
