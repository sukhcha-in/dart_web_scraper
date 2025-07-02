import 'dart:convert';

/// Cleaner cleans URLs based on configuration in Target.
class UrlCleaner {
  /// List of parameters to keep them in cleaned URL.
  List<String>? whitelistParams;

  /// List of parameters to remove them from cleaned URL.
  List<String>? blacklistParams;

  /// Extra parameters to append to cleaned URL.
  Map<String, String>? appendParams;

  UrlCleaner({
    this.whitelistParams,
    this.blacklistParams,
    this.appendParams,
  });

  /// Creates a UrlCleaner instance from Map.
  factory UrlCleaner.fromMap(Map<String, dynamic> map) {
    return UrlCleaner(
      whitelistParams: map['whitelistParams'] != null
          ? List<String>.from(map['whitelistParams'])
          : null,
      blacklistParams: map['blacklistParams'] != null
          ? List<String>.from(map['blacklistParams'])
          : null,
      appendParams: map['appendParams'] != null
          ? Map<String, String>.from(map['appendParams'])
          : null,
    );
  }

  /// Converts the UrlCleaner instance to Map.
  Map<String, dynamic> toMap() {
    return {
      'whitelistParams': whitelistParams,
      'blacklistParams': blacklistParams,
      'appendParams': appendParams,
    };
  }

  /// Creates a UrlCleaner instance from a JSON string.
  factory UrlCleaner.fromJson(String json) {
    return UrlCleaner.fromMap(jsonDecode(json));
  }

  /// Converts the UrlCleaner instance to a JSON string.
  String toJson() {
    return jsonEncode(toMap());
  }
}
