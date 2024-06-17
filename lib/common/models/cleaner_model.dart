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
}
