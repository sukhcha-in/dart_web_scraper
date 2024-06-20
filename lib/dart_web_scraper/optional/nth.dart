import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? nthOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.nth != null && data is List) {
      if (data.length >= (parser.optional!.nth! + 1)) {
        return data[parser.optional!.nth!];
      }
    }
  } catch (e) {
    printLog(
      "Error in function nthOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
