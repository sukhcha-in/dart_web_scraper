import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? cropEndOptional(Parser parser, Object data, bool debug) {
  int? cropEnd = parser.optional!.cropEnd;
  try {
    Object tmp = data;
    if (cropEnd != null) {
      if (tmp is List) {
        if (cropEnd <= tmp.length) {
          tmp.removeRange(tmp.length - cropEnd, tmp.length);
          return tmp;
        }
      } else if (tmp is String) {
        if (tmp.length >= cropEnd && cropEnd > 0) {
          return tmp.substring(0, tmp.length - cropEnd).trim();
        }
      }
    }
  } catch (e) {
    printLog(
      "Error in function cropEndOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
