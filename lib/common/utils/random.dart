import 'dart:math';
import 'package:dart_web_scraper/common/enums.dart';

final _rng = Random();

int _randInt(int min, int max) => min + _rng.nextInt(max - min + 1);
T _oneOf<T>(List<T> list) => list[_rng.nextInt(list.length)];

// Chrome versions from modern builds
int _chromeMajor() => _randInt(100, 127);
String _chromeVersion(int major) =>
    "$major.0.${_randInt(3000, 6000)}.${_randInt(50, 200)}";

/// Internal browser identity: the User-Agent plus the metadata needed to emit
/// matching client-hint headers. [chromeMajor] is null for non-Chromium
/// browsers (Safari), which do not send `Sec-CH-UA` hints.
typedef _Identity = ({
  String ua,
  String platform, // value for Sec-CH-UA-Platform
  bool mobile,
  int? chromeMajor,
});

// ---------- DESKTOP ----------

_Identity _windowsDesktop() {
  final win = _oneOf(["10.0", "11.0"]);
  final major = _chromeMajor();
  final ua = "Mozilla/5.0 (Windows NT $win; Win64; x64) "
      "AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/${_chromeVersion(major)} Safari/537.36";
  return (ua: ua, platform: "Windows", mobile: false, chromeMajor: major);
}

_Identity _macDesktop() {
  final major = _randInt(10, 14); // 10.x through Sonoma
  final minor = major == 10 ? _randInt(11, 15) : _randInt(0, 7);
  final patch = _randInt(0, 9);
  final chrome = _chromeMajor();
  final ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X ${major}_${minor}_$patch) "
      "AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/${_chromeVersion(chrome)} Safari/537.36";
  return (ua: ua, platform: "macOS", mobile: false, chromeMajor: chrome);
}

_Identity _linuxDesktop() {
  final distros = [
    "Ubuntu; Linux x86_64",
    "Fedora; Linux x86_64",
    "Linux x86_64"
  ];
  final distro = _oneOf(distros);
  final chrome = _chromeMajor();
  final ua = "Mozilla/5.0 (X11; $distro) "
      "AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/${_chromeVersion(chrome)} Safari/537.36";
  return (ua: ua, platform: "Linux", mobile: false, chromeMajor: chrome);
}

// ---------- MOBILE ----------

_Identity _androidMobile() {
  final androidMajor = _randInt(8, 14);
  final androidMinor = androidMajor <= 10 ? _randInt(0, 3) : 0;
  final androidVersion =
      androidMinor > 0 ? "$androidMajor.$androidMinor" : "$androidMajor";

  final devices = [
    "Pixel ${_randInt(3, 8)}",
    "SM-G${_randInt(950, 999)}F", // Galaxy S9-ish
    "SM-G${_randInt(991, 999)}B", // S21–S23-ish
    "M${_randInt(2000, 2999)}J${_randInt(1, 9)}SG", // Xiaomi-style
  ];
  final device = _oneOf(devices);
  final chrome = _chromeMajor();

  final ua = "Mozilla/5.0 (Linux; Android $androidVersion; $device) "
      "AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/${_chromeVersion(chrome)} Mobile Safari/537.36";
  return (ua: ua, platform: "Android", mobile: true, chromeMajor: chrome);
}

_Identity _iPhoneSafari() {
  final iosMajor = _randInt(14, 17);
  final iosMinor = _randInt(0, 7);
  final iosPatch = _randInt(0, 3);
  final iosToken = iosPatch > 0
      ? "${iosMajor}_${iosMinor}_$iosPatch"
      : "${iosMajor}_$iosMinor";

  const webkit = "605.1.15";
  final mobileBuilds = [
    "15E${_randInt(100, 999)}",
    "16E${_randInt(100, 999)}",
    "19A${_randInt(100, 999)}",
    "20F${_randInt(1000, 9999)}"
  ];
  final mobileBuild = _oneOf(mobileBuilds);

  final ua = "Mozilla/5.0 (iPhone; CPU iPhone OS $iosToken like Mac OS X) "
      "AppleWebKit/$webkit (KHTML, like Gecko) "
      "Version/$iosMajor.$iosMinor Mobile/$mobileBuild Safari/604.1";
  // Safari is not Chromium: no client hints.
  return (ua: ua, platform: "iOS", mobile: true, chromeMajor: null);
}

// ---------- IDENTITY SELECTION ----------

_Identity _identity(UserAgentDevice type) {
  switch (type) {
    case UserAgentDevice.mobile:
      return _oneOf([_androidMobile(), _iPhoneSafari()]);
    case UserAgentDevice.desktop:
      return _oneOf([_windowsDesktop(), _macDesktop(), _linuxDesktop()]);
    case UserAgentDevice.random:
      return _oneOf([
        _windowsDesktop(),
        _macDesktop(),
        _linuxDesktop(),
        _androidMobile(),
        _iPhoneSafari()
      ]);
    case UserAgentDevice.android:
      return _androidMobile();
    case UserAgentDevice.ios:
      return _iPhoneSafari();
    case UserAgentDevice.windows:
      return _windowsDesktop();
    case UserAgentDevice.linux:
      return _linuxDesktop();
    case UserAgentDevice.mac:
      return _macDesktop();
  }
}

// ---------- PUBLIC API ----------

/// A browser identity: a User-Agent string plus the request headers a real
/// browser of that type would send alongside it (Accept, client hints,
/// Sec-Fetch). Keeping these consistent avoids the easy "UA claims Chrome but
/// sends no client hints" bot tell.
///
/// Note: this only addresses header-level fingerprinting. TLS/JA3 and HTTP/2
/// fingerprints are determined by the Dart networking stack and cannot be
/// changed here — route through a `ProxyAPIConfig` unblocker for targets that
/// fingerprint at those layers.
class BrowserProfile {
  /// The generated User-Agent string.
  final String userAgent;

  /// Headers matching [userAgent]. Does NOT include the `User-Agent` header
  /// itself, so callers can decide its precedence.
  final Map<String, String> headers;

  BrowserProfile(this.userAgent, this.headers);
}

/// Returns a random User-Agent string for the given [type].
String randomUserAgent(UserAgentDevice type) => _identity(type).ua;

/// Returns a random [BrowserProfile] (User-Agent + matching headers) for the
/// given [type].
BrowserProfile randomBrowserProfile(UserAgentDevice type) {
  final id = _identity(type);
  return BrowserProfile(id.ua, _headersFor(id));
}

/// Builds a coherent set of request headers for [type] (a browser fingerprint)
/// and overlays caller-supplied [explicit] headers on top so they always win.
///
/// If the caller forces a User-Agent — via [overrideUserAgent] or a
/// `User-Agent` key in [explicit] — the generated `Sec-CH-UA*` client hints are
/// dropped, since they would no longer match that UA and a mismatch is itself a
/// detection signal.
Map<String, String> buildBrowserHeaders(
  UserAgentDevice type, {
  Map<String, String> explicit = const {},
  String? overrideUserAgent,
}) {
  final profile = randomBrowserProfile(type);
  final bool hasExplicitUA =
      explicit.keys.any((k) => k.toLowerCase() == 'user-agent');
  final bool customUA = overrideUserAgent != null || hasExplicitUA;

  final headers = <String, String>{...profile.headers};
  if (customUA) {
    headers.removeWhere((k, _) => k.toLowerCase().startsWith('sec-ch-ua'));
  }
  headers['User-Agent'] = profile.userAgent;

  // Caller-supplied headers take precedence.
  headers.addAll(explicit);

  // An explicit override wins over everything, including a UA in [explicit].
  if (overrideUserAgent != null) {
    headers['User-Agent'] = overrideUserAgent;
  }

  return headers;
}

/// Builds the headers that accompany a given browser [_Identity].
///
/// `Accept-Encoding` is intentionally omitted: the Dart HTTP stack only
/// auto-decompresses gzip, so advertising `br`/`deflate` (as real browsers do)
/// would yield bodies we cannot decode. Leaving it unset lets the client send
/// its safe default.
Map<String, String> _headersFor(_Identity id) {
  final headers = <String, String>{
    'Accept-Language': 'en-US,en;q=0.9',
    'Upgrade-Insecure-Requests': '1',
    'Sec-Fetch-Dest': 'document',
    'Sec-Fetch-Mode': 'navigate',
    'Sec-Fetch-Site': 'none',
    'Sec-Fetch-User': '?1',
  };

  if (id.chromeMajor != null) {
    // Chromium browsers: full Accept string + client hints.
    headers['Accept'] =
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,'
        'image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7';
    final major = id.chromeMajor;
    headers['sec-ch-ua'] =
        '"Chromium";v="$major", "Google Chrome";v="$major", "Not?A_Brand";v="24"';
    headers['sec-ch-ua-mobile'] = id.mobile ? '?1' : '?0';
    headers['sec-ch-ua-platform'] = '"${id.platform}"';
  } else {
    // Safari: simpler Accept, and no client hints.
    headers['Accept'] =
        'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
  }

  return headers;
}
