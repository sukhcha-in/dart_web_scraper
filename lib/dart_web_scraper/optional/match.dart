import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? matchOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.match != null) {
      printLog(
        "Matching ${parser.optional!.match.toString()} with '${data.toString()}'",
        debug,
        color: LogColor.yellow,
      );
      for (final m in parser.optional!.match!) {
        if (data.toString().trim().contains(m.toString().trim())) {
          return true;
        }
      }
      if (data != true) {
        return false;
      }
    }
  } catch (e) {
    printLog(
      "Error in function matchOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
