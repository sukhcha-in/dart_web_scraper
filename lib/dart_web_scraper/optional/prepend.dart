import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? prependOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.prepend != null) {
      if (data is List) {
        List tmp = [];
        for (final d in data) {
          tmp.add(parser.optional!.prepend! + d);
        }
        return tmp;
      } else {
        return parser.optional!.prepend! + data.toString();
      }
    }
  } catch (e) {
    printLog(
      "Error in function prependOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
