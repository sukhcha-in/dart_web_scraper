import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? imageParser(
  Parser parser,
  Data parentData,
  Map<String, Object> allData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("Starting Image Parser...", debug, color: LogColor.cyan);
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Image Parser: Element not found!",
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
    printLog("Image Selector: $sel", debug, color: LogColor.cyan);
    String selector;
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
