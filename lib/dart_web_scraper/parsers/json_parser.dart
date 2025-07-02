import 'package:dart_web_scraper/common/utils/data_extraction.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:json_path/json_path.dart';
import 'package:json_path/fun_extra.dart';

/// Extracts data from JSON using JSONPath selectors
/// Returns Data object with extracted JSON data or null if not found
Data? jsonParser({
  required Parser parser,
  required Data parentData,
  required Map<String, Object> allData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: JSON", debug, color: LogColor.cyan);

  // Handle case with no selectors - return decoded JSON
  if (parser.selectors.isEmpty) {
    printLog("No Selector! Decoding JSON...", debug, color: LogColor.cyan);
    Object? json = getJsonObject(parentData, debug);
    if (json != null) {
      printLog("Returning decoded JSON...", debug, color: LogColor.green);
      return Data(parentData.url, json);
    }
    printLog("Failed to decode JSON!", debug, color: LogColor.orange);
    return null;
  }

  // Get JSON data from parent
  Object? json = getJsonObject(parentData, debug);
  if (json == null) {
    printLog(
      "Unable to find JSON!",
      debug,
      color: LogColor.green,
    );
    return null;
  }

  // Try each JSONPath selector until data is found
  for (final s in parser.selectors) {
    printLog("JSON Selector: $s", debug, color: LogColor.cyan);
    String selector;

    // Handle dynamic selectors with slot injection
    if (s.contains("<slot>")) {
      selector = inject("slot", allData, s);
      printLog(
        "JSON Selector Modified: $selector",
        debug,
        color: LogColor.green,
      );
    } else {
      selector = s;
    }

    // Parse JSONPath with custom functions if needed
    JsonPath? jsonPath;
    if (selector.contains("key(@)")) {
      JsonPathParser parser = JsonPathParser(functions: [const Key()]);
      jsonPath = parser.parse(selector);
    }

    jsonPath ??= JsonPath(selector);

    // Extract data using JSONPath
    Iterable<Object?> data = jsonPath.readValues(json);
    if (parser.multiple) {
      // Return all matching values
      if (data.isNotEmpty) {
        if (data.first is List) {
          return Data(parentData.url, data.first as List);
        } else {
          return Data(parentData.url, data.toList());
        }
      }
    } else {
      // Return first matching value
      if (data.isNotEmpty) {
        Object? first = data.first;
        if (first != null) {
          return Data(parentData.url, first);
        }
      }
    }
  }

  printLog(
    "JSON Parser: No data found!",
    debug,
    color: LogColor.orange,
  );
  return null;
}
