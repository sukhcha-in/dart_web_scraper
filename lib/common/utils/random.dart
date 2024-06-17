import 'dart:math';

import 'package:dart_web_scraper/common/enums.dart';

/// Generate random number between min and max
int randomNumber(int min, int max) {
  return min + Random().nextInt(max - min);
}

/// Generate random user agent based on device type
String randomUserAgent(UserAgentDevice type) {
  if (type == UserAgentDevice.desktop) {
    return "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_${randomNumber(11, 15)}_${randomNumber(4, 9)}) AppleWebKit/${randomNumber(530, 537)}.${randomNumber(30, 37)} (KHTML, like Gecko) Chrome/${randomNumber(80, 105)}.0.${randomNumber(3000, 4500)}.${randomNumber(60, 125)} Safari/${randomNumber(530, 537)}.${randomNumber(30, 36)}";
  } else {
    return "Mozilla/5.0 (Linux; Android ${randomNumber(8, 13)}) AppleWebKit/${randomNumber(530, 537)}.${randomNumber(30, 36)} (KHTML, like Gecko) Chrome/${randomNumber(101, 116)}.0.${randomNumber(3000, 6000)}.${randomNumber(60, 125)} Mobile Safari/${randomNumber(530, 537)}.${randomNumber(30, 36)}";
  }
}
