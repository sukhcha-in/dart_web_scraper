// This file contains utility functions to work with cookies.

/// Converts a map of cookies to a string.
String mapToCookie(Map<String, String> cookies) {
  List<String> cookieList = [];
  cookies.forEach((key, value) {
    cookieList.add('$key=$value');
  });
  String cookieStr = cookieList.join(', ').trim();
  if (cookieStr != "") {
    return cookieStr;
  } else {
    return "";
  }
}

/// Joins two cookie strings.
String? joinCookies(String? staticCookies, String? cookies) {
  if (cookies == null && staticCookies == null) {
    return null;
  }

  final trimmedCookies = cookies?.trim();
  final trimmedStaticCookies = staticCookies?.trim();

  if (trimmedCookies == null || trimmedCookies.isEmpty) {
    if (trimmedStaticCookies != "") {
      return trimmedStaticCookies;
    }
    return null;
  }

  if (trimmedStaticCookies == null || trimmedStaticCookies.isEmpty) {
    if (trimmedCookies != "") {
      return trimmedCookies;
    }
    return null;
  }

  Map<String, String> parsedCookies = parseCookies(trimmedCookies);
  Map<String, String> parsedStaticCookies = parseCookies(trimmedStaticCookies);

  Map<String, String> mergedCookies = {...parsedStaticCookies};

  parsedCookies.forEach((key, value) {
    if (!mergedCookies.containsKey(key)) {
      mergedCookies[key] = value;
    }
  });

  return mapToCookie(mergedCookies);
}

/// Parses a cookie string to a map.
Map<String, String> parseCookies(String cookieString) {
  List<String> cookieList = cookieString.split('; ');

  Map<String, String> cookies = {};

  for (String cookie in cookieList) {
    List<String> cookieParts = cookie.split('=');
    if (cookieParts.length == 2) {
      String name = cookieParts[0];
      String value = cookieParts[1];
      cookies[name] = value;
    }
  }

  return cookies;
}
