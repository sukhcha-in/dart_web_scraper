import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? cropStartOptional(Parser parser, Object data, bool debug) {
  int? cropStart = parser.optional!.cropStart;
  try {
    Object tmp = data;
    if (cropStart != null) {
      if (tmp is List) {
        if (tmp.length >= cropStart) {
          tmp.removeRange(0, cropStart);
          return tmp;
        }
      } else if (tmp is String) {
        if (tmp.length >= cropStart && cropStart > 0) {
          return tmp.substring(cropStart).trim();
        }
      }
    }
  } catch (e) {
    printLog(
      "Error in function cropStartOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
