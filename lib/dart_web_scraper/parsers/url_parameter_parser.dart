import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? urlParamParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
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
    if (parser.selectors.first.contains("<slot>")) {
      selector = inject("slot", allData, parser.selectors.first);
    } else {
      selector = parser.selectors.first;
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
