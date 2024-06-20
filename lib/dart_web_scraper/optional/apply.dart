import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? applyOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.apply != null) {
      switch (parser.optional!.apply) {
        case ApplyMethod.urldecode:
          return Uri.decodeFull(data.toString());
        case ApplyMethod.mapToList:
          if (data is Map) {
            return data.values.toList();
          }
        default:
      }
    }
  } catch (e) {
    printLog(
      "Error in function applyOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
