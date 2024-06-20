import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? regexReplaceOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.regexReplace != null) {
      final re = RegExp(parser.optional!.regexReplace!);
      String replaceWith = "";
      if (parser.optional!.regexReplaceWith != null) {
        replaceWith = parser.optional!.regexReplaceWith!;
      }
      if (data is List) {
        List<String> cleanedData = [];
        for (final l in data as Iterable) {
          String sanitized = l.toString().replaceAll(re, replaceWith);
          if (sanitized != "") {
            cleanedData.add(sanitized.trim());
          }
        }
        if (cleanedData.isNotEmpty) {
          return cleanedData;
        }
      } else {
        String? sanitized = (data as String).replaceAll(re, replaceWith);
        if (sanitized != "") {
          return sanitized;
        }
      }
    }
  } catch (e) {
    printLog(
      "Error in function regexReplaceOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
