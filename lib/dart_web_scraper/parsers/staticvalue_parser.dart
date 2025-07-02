import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Returns static values configured in parser options
/// Returns Data object with static string or map value or null if not configured
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

  // Return static string value if configured
  if (parser.parserOptions?.staticValue?.stringValue != null) {
    return Data(
        parentData.url, parser.parserOptions!.staticValue!.stringValue!);
  }
  // Return static map value if configured
  else if (parser.parserOptions?.staticValue?.mapValue != null) {
    return Data(parentData.url, parser.parserOptions!.staticValue!.mapValue!);
  }
  // No static value configured
  else {
    printLog(
      "Static Value Parser: No data found!",
      debug,
      color: LogColor.red,
    );
    return null;
  }
}
