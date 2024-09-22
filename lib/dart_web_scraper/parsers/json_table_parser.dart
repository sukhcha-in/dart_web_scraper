import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/json_parser.dart';

Data? jsonTableParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: JSON Table", debug, color: LogColor.cyan);
  Object? json = getJsonObject(parentData, debug);
  json ??= getStringObject(parentData);

  // try {
  Map<String, Object> result = {};
  Data? parsed = jsonParser(
    parser: parser,
    parentData: Data(parentData.url, json),
    allData: allData,
    debug: debug,
  );
  if (parsed != null && parsed.obj is Iterable) {
    for (final p in parsed.obj as Iterable) {
      Data? keyData = jsonParser(
        parser: Parser(
          id: "key",
          parent: ["parent"],
          type: ParserType.json,
          selector: [parser.optional!.keys!],
        ),
        parentData: Data(parentData.url, p),
        allData: allData,
        debug: debug,
      );
      Data? valData = jsonParser(
        parser: Parser(
          id: "val",
          parent: ["parent"],
          type: ParserType.json,
          selector: [parser.optional!.values!],
        ),
        parentData: Data(parentData.url, p),
        allData: allData,
        debug: debug,
      );
      if (keyData != null && valData != null) {
        if (keyData.obj is String && valData.obj is String) {
          result.addAll({keyData.obj as String: valData.obj as String});
        } else if (keyData.obj is List && valData.obj is List) {
          if ((keyData.obj as List).length == (valData.obj as List).length) {
            for (int i = 0; i < (keyData.obj as List).length; i++) {
              result
                  .addAll({(keyData.obj as List)[i]: (valData.obj as List)[i]});
            }
          }
        }
      }
    }
    result.removeWhere((key, value) => key.isEmpty);
    result.removeWhere((key, value) => value.toString().isEmpty);
    return Data(parentData.url, result);
  }
  printLog(
    "JSON Table Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
  // } catch (e) {
  //   printLog("Error in json_table_parser: $e", true, color: LogColor.red);
  //   return null;
  // }
}
