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

  /// Creates a UrlCleaner instance from a JSON map.
  factory UrlCleaner.fromJson(Map<String, dynamic> json) {
    return UrlCleaner(
      whitelistParams: json['whitelistParams'] != null
          ? List<String>.from(json['whitelistParams'])
          : null,
      blacklistParams: json['blacklistParams'] != null
          ? List<String>.from(json['blacklistParams'])
          : null,
      appendParams: json['appendParams'] != null
          ? Map<String, String>.from(json['appendParams'])
          : null,
    );
  }

  /// Converts the UrlCleaner instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'whitelistParams': whitelistParams,
      'blacklistParams': blacklistParams,
      'appendParams': appendParams,
    };
  }
}
