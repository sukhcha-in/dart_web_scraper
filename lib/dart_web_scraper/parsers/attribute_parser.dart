import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? attributeParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Attribute", debug, color: LogColor.cyan);
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Attribute Parser: Element not found!",
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
    printLog("Attribute Selector: $sel", debug, color: LogColor.cyan);
    String selector;
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
    List<String> split = selector.toString().split("::");

    Object? data = attrHandler(
      parser,
      document,
      selectr: split[0],
      attr: split[1],
    );
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

Object? attrHandler(
  Parser parser,
  Element source, {
  required String selectr,
  required String attr,
}) {
  if (parser.multiple) {
    List<Element> selector = source.querySelectorAll(selectr);
    if (selector.isNotEmpty) {
      List<String> result = [];
      for (final sel in selector) {
        String? attribute = sel.attributes[attr];
        if (attribute != null) {
          result.add(attribute.toString());
        }
      }
      return result;
    }
  } else {
    Element? selector = source.querySelector(selectr);
    if (selector != null) {
      String? attribute = selector.attributes[attr];
      if (attribute != null) {
        return attribute.toString();
      }
    }
  }
  return null;
}
