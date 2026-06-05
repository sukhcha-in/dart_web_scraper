// This file contains utility functions to work with cookies.

/// Converts a map of cookies to a string.
String mapToCookie(Map<String, String> cookies) {
  List<String> cookieList = [];
  cookies.forEach((key, value) {
    cookieList.add('$key=$value');
  });
  String cookieStr = cookieList.join('; ').trim();
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

/// Extracts a single cookie's value from a `set-cookie` (or similar) header value.
///
/// A `set-cookie` header looks like `name=value; Path=/; HttpOnly` and multiple
/// cookies may be comma-joined. This finds the `[cookieName]=value` token and
/// returns just its value (up to the next `;` or `,`), or null if not present.
/// Unlike [parseCookies], it tolerates `=` characters inside the value (e.g.
/// base64-encoded tokens).
String? extractCookieFromHeader(String headerValue, String cookieName) {
  final RegExp regex = RegExp(
    '(?:^|[;,]\\s*)${RegExp.escape(cookieName)}=([^;,]*)',
  );
  return regex.firstMatch(headerValue)?.group(1);
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
