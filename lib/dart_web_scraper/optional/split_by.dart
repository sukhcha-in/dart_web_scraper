import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? splitByOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.splitBy != null && data is String) {
      if (data.contains(parser.optional!.splitBy!)) {
        return data.split(parser.optional!.splitBy!);
      }
    }
  } catch (e) {
    printLog(
      "Error in function splitByOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
