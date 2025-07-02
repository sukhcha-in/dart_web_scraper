import 'package:json5/json5.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Decodes JSON5 format strings into Dart objects
/// Returns Data object with parsed JSON5 data or null if parsing fails
Data? json5DecodeParser({
  required Parser parser,
  required Data parentData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog(
    "ID: ${parser.id} Parser: JSON 5 Decode",
    debug,
    color: LogColor.cyan,
  );
  try {
    // Parse JSON5 string from parent data
    return Data(parentData.url, JSON5.parse(parentData.obj as String));
  } catch (e) {
    printLog(
      "JSON5Decode Parser: $e",
      debug,
      color: LogColor.red,
    );
    return null;
  }
}
