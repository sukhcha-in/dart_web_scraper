import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? staticValueParser({
  required Parser parser,
  required Data parentData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog(
    "ID: ${parser.id} Parser: Static Value",
    debug,
    color: LogColor.cyan,
  );
  if (parser.parserOptions?.staticValue?.stringValue != null) {
    return Data(
        parentData.url, parser.parserOptions!.staticValue!.stringValue!);
  } else if (parser.parserOptions?.staticValue?.mapValue != null) {
    return Data(parentData.url, parser.parserOptions!.staticValue!.mapValue!);
  } else {
    printLog(
      "Static Value Parser: No data found!",
      debug,
      color: LogColor.red,
    );
    return null;
  }
}
