import 'dart:convert';

import 'package:dart_web_scraper/dart_web_scraper.dart';

class ScraperConfigMap {
  final Map<String, List<ScraperConfig>> configs;
  final int? useNth;

  ScraperConfigMap({
    required this.configs,
    this.useNth,
  });

  factory ScraperConfigMap.fromMap(Map<String, dynamic> map) {
    final raw = map['configs'] as Map<String, dynamic>? ?? const {};
    final parsed = raw.map<String, List<ScraperConfig>>((key, value) {
      final list = (value as List<dynamic>)
          .map((e) => ScraperConfig.fromMap(e as Map<String, dynamic>))
          .toList();
      return MapEntry(key, list);
    });

    return ScraperConfigMap(
      configs: parsed,
      useNth: map['useNth'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'configs': configs
            .map((k, v) => MapEntry(k, v.map((c) => c.toMap()).toList())),
        'useNth': useNth,
      };

  factory ScraperConfigMap.fromJson(String source) =>
      ScraperConfigMap.fromMap(jsonDecode(source) as Map<String, dynamic>);

  String toJson() => jsonEncode(toMap());
}
