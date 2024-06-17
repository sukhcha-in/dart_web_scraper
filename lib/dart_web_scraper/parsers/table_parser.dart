import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? tableParser(
  Parser parser,
  Data parentData,
  Map<String, Object> allData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("Starting Table Parser...", debug, color: LogColor.cyan);
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "Table Parser: Element not found!",
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
    printLog("Table Selector: $sel", debug, color: LogColor.cyan);
    String selector;
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "Table Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }
    List<Element> elements = document.querySelectorAll(selector);
    if (elements.isEmpty) {
      continue;
    }
    Map<String, String> result = {};
    if (elements.isNotEmpty) {
      for (final element in elements) {
        if (parser.optional != null && parser.optional!.keys != null) {
          Element? keySelector = element.querySelector(parser.optional!.keys!);
          String? key = keySelector?.text;
          String? value;
          if (parser.optional!.values != null) {
            value = element.querySelector(parser.optional!.values!)?.text;
          } else {
            value = keySelector?.nextElementSibling?.text;
          }
          if (key != null && value != null) {
            value = value.replaceAll(RegExp('[^\x00-\x7F]+'), '');
            if (key.trim() != "" && value.trim() != "") {
              result.addAll({key.trim(): value.trim()});
            }
          }
        } else {
          if (element.text.trim() != "" &&
              element.nextElementSibling!.text.trim() != "") {
            result.addAll(
                {element.text.trim(): element.nextElementSibling!.text.trim()});
          }
        }
      }
      return Data(parentData.url, result);
    }
  }
  printLog(
    "Table Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}
