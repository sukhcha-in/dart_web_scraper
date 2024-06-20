import 'package:dart_web_scraper/dart_web_scraper.dart';

Object? replaceOptional(Parser parser, Object data, bool debug) {
  try {
    if (parser.optional!.replaceFirst != null ||
        parser.optional!.replaceAll != null) {
      String type = "first";
      if (parser.optional!.replaceAll != null) {
        type = "all";
      }
      if (data is List) {
        List tmpR = [];
        for (final r in data) {
          var tmpD = r;
          if (type == "first") {
            parser.optional!.replaceFirst!.forEach((key, value) {
              tmpD = tmpD.toString().replaceFirst(key, value);
            });
          } else {
            parser.optional!.replaceAll!.forEach((key, value) {
              tmpD = tmpD.toString().replaceAll(key, value);
            });
          }
          tmpR.add(tmpD);
        }
        return tmpR;
      } else {
        Object tmpS = data;
        if (type == "first") {
          parser.optional!.replaceFirst!.forEach((key, value) {
            tmpS = tmpS.toString().replaceFirst(key, value);
          });
        } else {
          parser.optional!.replaceAll!.forEach((key, value) {
            tmpS = tmpS.toString().replaceAll(key, value);
          });
        }
        return tmpS;
      }
    }
  } catch (e) {
    printLog(
      "Error in function replaceOptional: $e",
      debug,
      color: LogColor.red,
    );
  }
  return null;
}
