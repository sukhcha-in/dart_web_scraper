import 'dart:convert';

class CropTransformationOptions {
  final int? cropStart;
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
