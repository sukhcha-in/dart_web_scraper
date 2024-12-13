import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Config for a domain
class Config {
  /// If TRUE scraper will forcefully fetch data from URL even if HTML is passed.
  /// Defaults to FALSE.
  bool forceFetch;

  /// Allow this domain to use passed HTML and skip fetching HTML from URL.
  bool usePassedHtml;

  /// Allow custom user agent passed by user.
  bool usePassedUserAgent;

  /// User Agent selections: [UserAgentDevice.desktop] or [UserAgentDevice.mobile]
  /// Defaults to [UserAgentDevice.mobile]
  UserAgentDevice userAgent;

  /// Map of parsers based on Target name.
  /// Set Target name as key and List of Parser as value.
  Map<String, List<Parser>> parsers;

  /// Targets are set based on page types of target website.
  List<UrlTarget> urlTargets;

  Config({
    this.forceFetch = false,
    this.userAgent = UserAgentDevice.mobile,
    this.usePassedHtml = true,
    this.usePassedUserAgent = false,
    required this.parsers,
    required this.urlTargets,
  });
}
