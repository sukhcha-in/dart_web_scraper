import 'package:json5/json5.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? json5DecodeParser(
  Parser parser,
  Data parentData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog(
    "ID: ${parser.id} Parser: JSON 5 Decode",
    debug,
    color: LogColor.cyan,
  );
  try {
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
