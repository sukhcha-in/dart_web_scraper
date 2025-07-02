import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:html/dom.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? stringBetweenParser({
  required Parser parser,
  required Data parentData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog(
    "ID: ${parser.id} Parser: String Between",
    debug,
    color: LogColor.cyan,
  );
  List<Element>? element = getElementObject(parentData);
  if (element == null || element.isEmpty) {
    printLog(
      "StringBetween Parser: Element not found!",
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

  String source = document.outerHtml;

  String tmp;
  String start = parser.parserOptions?.stringBetween?.start ?? "";
  String end = parser.parserOptions?.stringBetween?.end ?? "";
  final startIndex = source.indexOf(start);
  if (startIndex == -1) {
    printLog(
      "StringBetween Parser: No data found!",
      debug,
      color: LogColor.orange,
    );
    return null;
  }
  final endIndex = source.indexOf(end, startIndex + start.length);
  try {
    tmp = source.substring(startIndex + start.length, endIndex);
  } catch (e) {
    printLog(
      "StringBetween Parser: No data found!",
      debug,
      color: LogColor.orange,
    );
    return null;
  }
  return Data(parentData.url, tmp.trim());
}
