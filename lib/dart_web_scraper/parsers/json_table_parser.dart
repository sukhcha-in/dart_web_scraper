import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:dart_web_scraper/dart_web_scraper/parsers/json_parser.dart';

/// Extracts key-value pairs from JSON data structures
/// Returns Data object with Map of key-value pairs or null if not found
Data? jsonTableParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: JSON Table", debug, color: LogColor.cyan);

  // Get JSON data from parent (try JSON first, then string)
  Object? json = getJsonObject(parentData, debug);
  json ??= getStringObject(parentData);

  // Validate that keys and values selectors are configured
  if (parser.parserOptions?.table?.keys == null ||
      parser.parserOptions?.table?.values == null) {
    printLog(
      "JSON Table Parser: Keys or values are not set!",
      debug,
      color: LogColor.red,
    );
    return null;
  }

  // Extract key-value pairs from JSON data
  Map<String, Object> result = {};
  Data? parsed = jsonParser(
    parser: parser,
    parentData: Data(parentData.url, json),
    allData: allData,
    debug: debug,
  );

  // Process each item in the JSON array/iterable
  if (parsed != null && parsed.obj is Iterable) {
    for (final p in parsed.obj as Iterable) {
      // Extract key using JSON parser
      Data? keyData = jsonParser(
        parser: Parser(
          id: "key",
          parents: ["parent"],
          type: ParserType.json,
          selectors: [parser.parserOptions!.table!.keys],
        ),
        parentData: Data(parentData.url, p),
        allData: allData,
        debug: debug,
      );

      // Extract value using JSON parser
      Data? valData = jsonParser(
        parser: Parser(
          id: "val",
          parents: ["parent"],
          type: ParserType.json,
          selectors: [parser.parserOptions!.table!.values!],
        ),
        parentData: Data(parentData.url, p),
        allData: allData,
        debug: debug,
      );

      // Handle different data types for keys and values
      if (keyData != null && valData != null) {
        if (keyData.obj is String && valData.obj is String) {
          // Simple string key-value pair
          result.addAll({keyData.obj as String: valData.obj as String});
        } else if (keyData.obj is List && valData.obj is List) {
          // Handle lists of keys and values
          if ((keyData.obj as List).length == (valData.obj as List).length) {
            for (int i = 0; i < (keyData.obj as List).length; i++) {
              result
                  .addAll({(keyData.obj as List)[i]: (valData.obj as List)[i]});
            }
          }
        }
      }
    }

    // Remove empty keys and values
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
}
