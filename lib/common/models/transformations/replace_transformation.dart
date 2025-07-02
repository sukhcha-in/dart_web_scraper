import 'dart:convert';

/// Configuration options for string replacement transformations.
///
/// This class provides options to perform string replacements on extracted data.
/// It supports both single replacements (replaceFirst) and multiple replacements (replaceAll).
class ReplaceTransformationOptions {
  /// Map of string pairs for single replacements.
  ///
  /// Each key-value pair represents a single replacement operation where
  /// the key is the string to find and the value is the string to replace it with.
  /// Only the first occurrence of each key will be replaced.
  final Map<String, String>? replaceFirst;

  /// Map of string pairs for multiple replacements.
  ///
  /// Each key-value pair represents a replacement operation where
  /// the key is the string to find and the value is the string to replace it with.
  /// All occurrences of each key will be replaced.
  final Map<String, String>? replaceAll;

  /// Creates a new ReplaceTransformationOptions instance.
  ///
  /// [replaceFirst] - Optional map for single replacements
  /// [replaceAll] - Optional map for multiple replacements
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
