import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/json_parser.dart';

Data? jsonTableParser(
  Parser parser,
  Data parentData,
  Map<String, Object> allData,
  bool debug,
) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: JSON Table", debug, color: LogColor.cyan);
  Object? json = getJsonObject(parentData, debug);
  json ??= getStringObject(parentData);

  // try {
  Map<String, Object> result = {};
  Data? parsed = jsonParser(
    parser,
    Data(parentData.url, json),
    allData,
    debug,
  );
  if (parsed != null && parsed.obj is Iterable) {
    for (final p in parsed.obj as Iterable) {
      Data? keyData = jsonParser(
        Parser(
          id: "key",
          parent: ["parent"],
          type: ParserType.json,
          selector: [parser.optional!.keys!],
        ),
        Data(parentData.url, p),
        allData,
        debug,
      );
      Data? valData = jsonParser(
        Parser(
          id: "val",
          parent: ["parent"],
          type: ParserType.json,
          selector: [parser.optional!.values!],
        ),
        Data(parentData.url, p),
        allData,
        debug,
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
