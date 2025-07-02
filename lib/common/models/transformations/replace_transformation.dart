import 'dart:convert';

class ReplaceTransformationOptions {
  final Map<String, String>? replaceFirst;
  final Map<String, String>? replaceAll;

  ReplaceTransformationOptions({
    this.replaceFirst,
    this.replaceAll,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'replaceFirst': replaceFirst,
      'replaceAll': replaceAll,
    };
  }

  factory ReplaceTransformationOptions.fromMap(Map<String, dynamic> map) {
    return ReplaceTransformationOptions(
      replaceFirst: map['replaceFirst'] != null
          ? Map<String, String>.from(map['replaceFirst'])
          : null,
      replaceAll: map['replaceAll'] != null
          ? Map<String, String>.from(map['replaceAll'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplaceTransformationOptions.fromJson(String source) =>
      ReplaceTransformationOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
