import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? urlParamParser(
  Parser parser,
  Data parentData,
  Map<String, Object> allData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog(
    "ID: ${parser.id} Parser: URL Parameter",
    debug,
    color: LogColor.cyan,
  );
  String document = getStringObject(parentData);
  try {
    Uri uri = Uri.parse(document);
    String selector;
    if (parser.selector.first.contains("<slot>")) {
      selector = inject("slot", allData, parser.selector.first);
    } else {
      selector = parser.selector.first;
    }
    if (uri.queryParameters.containsKey(selector)) {
      return Data(parentData.url, uri.queryParameters[selector]!);
    }
  } catch (e) {
    printLog(
      "URL Parameter Parser: $e",
      debug,
      color: LogColor.red,
    );
    return null;
  }
  printLog(
    "URL Parameter Parser: No data found!",
    debug,
    color: LogColor.red,
  );
  return null;
}
