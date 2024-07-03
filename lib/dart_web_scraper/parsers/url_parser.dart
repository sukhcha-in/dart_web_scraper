import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? urlParser(
  Parser parser,
  Data parentData,
  Map<String, Object> allData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: URL", debug, color: LogColor.cyan);

  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "URL Parser: Element not found!",
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
    printLog("URL Parser Selector: $sel", debug, color: LogColor.cyan);
    String selector;
    if (sel.contains("<slot>")) {
      selector = inject("slot", allData, sel);
      printLog(
        "URL Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = sel;
    }
    Element? elm = document.querySelector(selector);
    if (elm != null) {
      String? attribute = elm.attributes['href'];
      if (attribute != null) {
        return Data(parentData.url, attribute.toString());
      }
    }
  }
  printLog(
    "URL Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}
