import 'dart:math';
import 'package:dart_web_scraper/common/enums.dart';

final _rng = Random();

int _randInt(int min, int max) => min + _rng.nextInt(max - min + 1);
T _oneOf<T>(List<T> list) => list[_rng.nextInt(list.length)];

// Chrome versions from modern builds
int _chromeMajor() => _randInt(100, 127);
String _chromeVersion() =>
    "${_chromeMajor()}.0.${_randInt(3000, 6000)}.${_randInt(50, 200)}";

// ---------- DESKTOP ----------

String _windowsDesktopUA() {
  final winVersions = ["10.0", "11.0"];
  final win = _oneOf(winVersions);
  return "Mozilla/5.0 (Windows NT $win; Win64; x64) "
      "AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/${_chromeVersion()} Safari/537.36";
}

String _macDesktopUA() {
  final major = _randInt(10, 14); // 10.x through Sonoma
  final minor = major == 10 ? _randInt(11, 15) : _randInt(0, 7);
  final patch = _randInt(0, 9);
  return "Mozilla/5.0 (Macintosh; Intel Mac OS X ${major}_${minor}_$patch) "
      "AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/${_chromeVersion()} Safari/537.36";
}

String _linuxDesktopUA() {
  final distros = [
    "Ubuntu; Linux x86_64",
    "Fedora; Linux x86_64",
    "Linux x86_64"
  ];
  final distro = _oneOf(distros);
  return "Mozilla/5.0 (X11; $distro) "
      "AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/${_chromeVersion()} Safari/537.36";
}

String _randomDesktopUA() =>
    _oneOf([_windowsDesktopUA(), _macDesktopUA(), _linuxDesktopUA()]);

// ---------- MOBILE ----------

String _androidMobileUA() {
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

  return "Mozilla/5.0 (Linux; Android $androidVersion; $device) "
      "AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/${_chromeVersion()} Mobile Safari/537.36";
}

String _iPhoneSafariUA() {
  final iosMajor = _randInt(14, 17);
  final iosMinor = _randInt(0, 7);
  final iosPatch = _randInt(0, 3);
  final iosToken = iosPatch > 0
      ? "${iosMajor}_${iosMinor}_$iosPatch"
      : "${iosMajor}_${iosMinor}";

  const webkit = "605.1.15";
  final mobileBuilds = [
    "15E${_randInt(100, 999)}",
    "16E${_randInt(100, 999)}",
    "19A${_randInt(100, 999)}",
    "20F${_randInt(1000, 9999)}"
  ];
  final mobileBuild = _oneOf(mobileBuilds);

  return "Mozilla/5.0 (iPhone; CPU iPhone OS $iosToken like Mac OS X) "
      "AppleWebKit/$webkit (KHTML, like Gecko) "
      "Version/$iosMajor.$iosMinor Mobile/$mobileBuild Safari/604.1";
}

String _randomMobileUA() => _oneOf([_androidMobileUA(), _iPhoneSafariUA()]);

// ---------- PUBLIC API ----------

String randomUserAgent(UserAgentDevice type) {
  switch (type) {
    case UserAgentDevice.mobile:
      return _randomMobileUA();
    case UserAgentDevice.desktop:
      return _randomDesktopUA();
    case UserAgentDevice.random:
      return _oneOf([
        _windowsDesktopUA(),
        _macDesktopUA(),
        _linuxDesktopUA(),
        _androidMobileUA(),
        _iPhoneSafariUA()
      ]);
    case UserAgentDevice.android:
      return _androidMobileUA();
    case UserAgentDevice.ios:
      return _iPhoneSafariUA();
    case UserAgentDevice.windows:
      return _windowsDesktopUA();
    case UserAgentDevice.linux:
      return _linuxDesktopUA();
    case UserAgentDevice.mac:
      return _macDesktopUA();
  }
}
