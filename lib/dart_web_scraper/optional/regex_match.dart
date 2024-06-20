import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? regexMatchOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.regex != null) {
      RegExp exp = RegExp(parser.optional!.regex!);
      RegExpMatch? regexed = exp.firstMatch(data.toString());
      if (regexed != null) {
        String? matched = regexed.group(parser.optional!.regexGroup ?? 0);
        if (matched != null) {
          return matched;
        }
      }
    }
  } catch (e) {
    printLog(
      "Error in function regexMatchOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
