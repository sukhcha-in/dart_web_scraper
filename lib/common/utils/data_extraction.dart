import 'dart:convert';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// Extracts Element from Data object
List<Element>? getElementObject(Data data) {
  Object? obj = data.obj;
  if (obj is Document) {
    return [obj.documentElement!];
  } else if (obj is Element) {
    return [obj];
  } else if (obj is List<Element>) {
    return obj;
  } else if (obj is String) {
    return [parse(obj).documentElement!];
  }
  return null;
}

/// Extracts String from Data object
String getStringObject(Data data) {
  Object obj = data.obj;
  if (obj is String) {
    return obj;
  }
  return obj.toString();
}

/// Extracts JsonObject from Data object
Object? getJsonObject(Data data, bool debug) {
  Object obj = data.obj;
  if (obj is String) {
    try {
      return jsonDecode(obj);
    } catch (e) {
      printLog(
        "Error in function getJsonObject: $e",
        debug,
        color: LogColor.red,
      );
      return null;
    }
  }
  return obj;
}
