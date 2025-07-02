import 'dart:convert';

/// Configuration options for trimming data from the beginning or end.
///
/// Removes specified portions from strings, lists, or other sequential data.
/// Similar to string trim but with configurable start/end positions.
///
/// Example usage:
/// ```dart
/// // Remove first 10 characters/items
/// CropTransformationOptions(cropStart: 10)
///
/// // Remove last 20 characters/items
/// CropTransformationOptions(cropEnd: 20)
/// ```
class CropTransformationOptions {
  /// The starting position for cropping (0-based index).
  final int? cropStart;

  /// The ending position for cropping (0-based index).
  final int? cropEnd;

  CropTransformationOptions({
    this.cropStart,
    this.cropEnd,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cropStart': cropStart,
      'cropEnd': cropEnd,
    };
  }

  factory CropTransformationOptions.fromMap(Map<String, dynamic> map) {
    return CropTransformationOptions(
      cropStart: map['cropStart'] != null ? map['cropStart'] as int : null,
      cropEnd: map['cropEnd'] != null ? map['cropEnd'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CropTransformationOptions.fromJson(String source) =>
      CropTransformationOptions.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
