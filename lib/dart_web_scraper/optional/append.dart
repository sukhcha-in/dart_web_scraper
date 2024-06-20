import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? appendOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.append != null) {
      if (data is List) {
        List tmp = [];
        for (final d in data) {
          tmp.add(d + parser.optional!.append!);
        }
        return tmp;
      } else {
        return data.toString() + parser.optional!.append!;
      }
    }
  } catch (e) {
    printLog(
      "Error in function appendOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
