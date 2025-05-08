import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Fetches config based on URL
Config? getConfig(
  Uri url, {
  required Map<String, List<Config>> configs,
  int configIndex = 0,
}) {
  for (final i in configs.keys) {
    // Wildcard: match any host
    if (i == '*') {
      Config? config = configs[i]!.firstWhereIndexedOrNull(
        (i, _) => i == configIndex,
      );
      return config ?? configs[i]![0];
    }
    // Regex: key starts and ends with '/'
    else if (i.length > 2 && i.startsWith('/') && i.endsWith('/')) {
      final pattern = RegExp(i.substring(1, i.length - 1));
      if (pattern.hasMatch(url.host)) {
        Config? config = configs[i]!.firstWhereIndexedOrNull(
          (i, _) => i == configIndex,
        );
        return config ?? configs[i]![0];
      }
    }
    // Legacy: substring match
    else if (url.host.contains(i)) {
      Config? config = configs[i]!.firstWhereIndexedOrNull(
        (i, _) => i == configIndex,
      );
      return config ?? configs[i]![0];
    }
  }
  return null;
}

/// Cleans URL based on cleaner
Uri cleanConfigUrl(Uri url, UrlCleaner? cleaner) {
  //Set variables
  Map<String, String> params = {};

  //Empty cleaner, return path only, no params!
  if (cleaner == null) {
    return Uri.https(url.authority, url.path);
  }

  //Blacklisted params! Add all other params.
  if (cleaner.blacklistParams != null) {
    url.queryParameters.forEach((key, value) {
      if (!cleaner.blacklistParams!.contains(key)) {
        params[key] = value;
      }
    });
  } else {
    params.addAll(url.queryParameters);
  }

  //Let's remove non-whitelisted params
  if (cleaner.whitelistParams != null) {
    List<String> toRemove = [];
    params.forEach((key, value) {
      if (!cleaner.whitelistParams!.contains(key)) {
        toRemove.add(key);
      }
    });
    params.removeWhere((k, v) => toRemove.contains(k));
  } else {
    params.clear();
  }

  //Let's append defined parameters
  if (cleaner.appendParams != null) {
    cleaner.appendParams!.forEach((key, value) {
      params[key] = value;
    });
  }

  return Uri.https(url.authority, url.path, params);
}

/// Fetches target based on URL
UrlTarget? fetchTarget(List<UrlTarget> targets, Uri url) {
  for (final t in targets) {
    for (final urlPart in t.where) {
      if (urlPart == "/") {
        return t;
      } else if (url.path.contains(urlPart)) {
        return t;
      } else {
        final pattern = RegExp(urlPart);
        if (pattern.hasMatch(url.toString())) {
          return t;
        }
      }
    }
  }
  return null;
}

/// Injects data into an Object
String inject(String name, Object data, Object input) {
  String result = input.toString();
  try {
    // Find all placeholders enclosed in <slot> tags
    RegExp slotRegExp = RegExp("<$name>(.*?)</$name>");
    Iterable<Match> matches = slotRegExp.allMatches(input.toString());

    if (data is Map) {
      // Iterate over matches and replace with values from params or "X"
      for (Match match in matches) {
        String slotName = match.group(1)!; // Extract the slot name
        String slotValue =
            data[slotName].toString(); // Use value from params or "X"
        result = result.replaceFirst(match.group(0)!, slotValue);
      }
      if (result.trim() == "") {
        return input.toString();
      }
    }
  } catch (e) {
    printLog("Injection Error: $e", true, color: LogColor.red);
  }
  return result;
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereIndexedOrNull(bool Function(int index, T element) test) {
    var index = 0;
    for (var element in this) {
      if (test(index++, element)) return element;
    }
    return null;
  }
}
