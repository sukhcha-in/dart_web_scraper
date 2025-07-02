import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Extracts URL parameters from a URL string
/// Returns Data object with parameter value or null if not found
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

  // Get URL string from parent data
  String document = getStringObject(parentData);
  try {
    // Parse URL to extract query parameters
    Uri uri = Uri.parse(document);
    String selector;
    String paramName = parser.parserOptions?.urlParam?.paramName ?? "";

    // Handle dynamic parameter names with slot injection
    if (paramName.contains("<slot>")) {
      selector = inject("slot", allData, paramName);
    } else {
      selector = paramName;
    }

    // Return parameter value if found
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
