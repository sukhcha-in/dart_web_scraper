import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? staticValueParser(
  Parser parser,
  Data parentData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("Starting Static Value Parser...", debug, color: LogColor.cyan);
  if (parser.optional?.strVal != null) {
    return Data(parentData.url, parser.optional!.strVal!);
  } else if (parser.optional?.mapVal != null) {
    return Data(parentData.url, parser.optional!.mapVal!);
  } else {
    printLog(
      "Static Value Parser: No data found!",
      debug,
      color: LogColor.red,
    );
    return null;
  }
}
