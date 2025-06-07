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

  /// Creates a Data instance from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      Uri.parse(json['url']),
      json['obj'],
    );
  }

  /// Converts the Data instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'url': url.toString(),
      'obj': obj,
    };
  }
}
