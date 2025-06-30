import 'dart:convert';

/// Data model which contains URL and data
class Data {
  /// Url
  Uri url;

  /// Data as Object?
  Object obj;

  Data(
    this.url,
    this.obj,
  );

  /// Creates a Data instance from Map.
  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      Uri.parse(map['url']),
      map['obj'],
    );
  }

  /// Converts the Data instance to Map.
  Map<String, dynamic> toMap() {
    return {
      'url': url.toString(),
      'obj': obj,
    };
  }

  /// Creates a Data instance from a JSON string.
  factory Data.fromJson(String json) {
    return Data.fromMap(jsonDecode(json));
  }

  /// Converts the Parser instance to a JSON string.
  String toJson() {
    return jsonEncode(toMap());
  }
}
