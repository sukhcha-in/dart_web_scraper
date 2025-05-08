import 'package:dart_web_scraper/dart_web_scraper.dart';

enum TransformationType {
  nth,
  splitBy,
  apply,
  replace,
  regexReplace,
  regexMatch,
  cropStart,
  cropEnd,
  prepend,
  append,
  match,
}

class Optional {
  // Common optional fields
  final ApplyMethod? apply;
  final String? regex;
  final int? regexGroup;
  final String? regexReplace;
  final String? regexReplaceWith;
  final Map<String, String>? replaceFirst;
  final Map<String, String>? replaceAll;
  final int? cropStart;
  final int? cropEnd;
  final String? prepend;
  final String? append;
  final List<Object>? match;
  final int? nth;
  final String? splitBy;

  // HTTP-specific fields
  final String? url;
  final HttpMethod? method;
  final Map<String, Object>? headers;
  final UserAgentDevice? userAgent;
  final HttpResponseType? responseType;
  final Object? payLoad;
  final HttpPayload? payloadType;
  final bool usePassedProxy;
  final bool cacheResponse;
  final HttpClientType clientType;

  // StrBetween-specific fields
  final String? start;
  final String? end;

  // Sibling-specific fields
  final List<String>? where;
  final SiblingDirection? siblingDirection;

  // Table-specific fields
  final String? keys;
  final String? values;

  // Static-specific fields
  final String? strVal;
  final Map<String, Object>? mapVal;

  /// The order in which transformations should be applied
  final List<TransformationType>? transformationOrder;

  // Precompiled RegExp for performance
  RegExp? _regex;
  RegExp? _regexReplaceRegExp;

  // Private constructor to enforce the use of named constructors
  Optional._({
    this.apply,
    this.regex,
    this.regexGroup,
    this.regexReplace,
    this.regexReplaceWith,
    this.replaceFirst,
    this.replaceAll,
    this.cropStart,
    this.cropEnd,
    this.prepend,
    this.append,
    this.match,
    this.nth,
    this.splitBy,
    this.url,
    this.method,
    this.headers,
    this.userAgent,
    this.responseType,
    this.payLoad,
    this.payloadType,
    this.usePassedProxy = false,
    this.cacheResponse = false,
    this.clientType = HttpClientType.browserClient,
    this.start,
    this.end,
    this.where,
    this.siblingDirection,
    this.keys,
    this.values,
    this.strVal,
    this.mapVal,
    this.transformationOrder,
  }) {
    // Precompile regex patterns if they exist
    if (regex != null) {
      _regex = RegExp(regex!);
    }
    if (regexReplace != null) {
      _regexReplaceRegExp = RegExp(regexReplace!);
    }
  }

  /// Named constructor for any optional parameters
  factory Optional.any({
    ApplyMethod? apply,
    String? regex,
    int? regexGroup,
    String? regexReplace,
    String? regexReplaceWith,
    Map<String, String>? replaceFirst,
    Map<String, String>? replaceAll,
    int? cropStart,
    int? cropEnd,
    String? prepend,
    String? append,
    List<Object>? match,
    int? nth,
    String? splitBy,
    List<TransformationType>? transformationOrder,
  }) {
    return Optional._(
      apply: apply,
      regex: regex,
      regexGroup: regexGroup,
      regexReplace: regexReplace,
      regexReplaceWith: regexReplaceWith,
      replaceFirst: replaceFirst,
      replaceAll: replaceAll,
      cropStart: cropStart,
      cropEnd: cropEnd,
      prepend: prepend,
      append: append,
      match: match,
      nth: nth,
      splitBy: splitBy,
      transformationOrder: transformationOrder,
    );
  }

  /// Named constructor for HTTP-specific optional parameters
  factory Optional.http({
    required String url,
    required HttpMethod method,
    Map<String, Object>? headers,
    UserAgentDevice? userAgent,
    HttpResponseType? responseType,
    Object? payLoad,
    HttpPayload? payloadType,
    bool usePassedProxy = false,
    bool cacheResponse = false,
    HttpClientType clientType = HttpClientType.browserClient,
    // Optional common fields
    ApplyMethod? apply,
    String? regex,
    int? regexGroup,
    String? regexReplace,
    String? regexReplaceWith,
    Map<String, String>? replaceFirst,
    Map<String, String>? replaceAll,
    int? cropStart,
    int? cropEnd,
    String? prepend,
    String? append,
    List<Object>? match,
    int? nth,
    String? splitBy,
    List<TransformationType>? transformationOrder,
  }) {
    return Optional._(
      url: url,
      method: method,
      headers: headers,
      userAgent: userAgent,
      responseType: responseType,
      payLoad: payLoad,
      payloadType: payloadType,
      usePassedProxy: usePassedProxy,
      cacheResponse: cacheResponse,
      clientType: clientType,
      apply: apply,
      regex: regex,
      regexGroup: regexGroup,
      regexReplace: regexReplace,
      regexReplaceWith: regexReplaceWith,
      replaceFirst: replaceFirst,
      replaceAll: replaceAll,
      cropStart: cropStart,
      cropEnd: cropEnd,
      prepend: prepend,
      append: append,
      match: match,
      nth: nth,
      splitBy: splitBy,
      transformationOrder: transformationOrder,
    );
  }

  /// Named constructor for StrBetween-specific optional parameters
  factory Optional.strBetween({
    required String start,
    required String end,
    // Optional common fields
    ApplyMethod? apply,
    String? regex,
    int? regexGroup,
    String? regexReplace,
    String? regexReplaceWith,
    Map<String, String>? replaceFirst,
    Map<String, String>? replaceAll,
    int? cropStart,
    int? cropEnd,
    String? prepend,
    String? append,
    List<Object>? match,
    int? nth,
    String? splitBy,
    List<TransformationType>? transformationOrder,
  }) {
    return Optional._(
      start: start,
      end: end,
      apply: apply,
      regex: regex,
      regexGroup: regexGroup,
      regexReplace: regexReplace,
      regexReplaceWith: regexReplaceWith,
      replaceFirst: replaceFirst,
      replaceAll: replaceAll,
      cropStart: cropStart,
      cropEnd: cropEnd,
      prepend: prepend,
      append: append,
      match: match,
      nth: nth,
      splitBy: splitBy,
      transformationOrder: transformationOrder,
    );
  }

  /// Named constructor for Sibling-specific optional parameters
  factory Optional.sibling({
    required SiblingDirection direction,
    List<String>? where,
    // Optional common fields
    ApplyMethod? apply,
    String? regex,
    int? regexGroup,
    String? regexReplace,
    String? regexReplaceWith,
    Map<String, String>? replaceFirst,
    Map<String, String>? replaceAll,
    int? cropStart,
    int? cropEnd,
    String? prepend,
    String? append,
    List<Object>? match,
    int? nth,
    String? splitBy,
    List<TransformationType>? transformationOrder,
  }) {
    return Optional._(
      siblingDirection: direction,
      where: where,
      apply: apply,
      regex: regex,
      regexGroup: regexGroup,
      regexReplace: regexReplace,
      regexReplaceWith: regexReplaceWith,
      replaceFirst: replaceFirst,
      replaceAll: replaceAll,
      cropStart: cropStart,
      cropEnd: cropEnd,
      prepend: prepend,
      append: append,
      match: match,
      nth: nth,
      splitBy: splitBy,
      transformationOrder: transformationOrder,
    );
  }

  /// Named constructor for Table-specific optional parameters
  factory Optional.table({
    String? keys,
    String? values,
    // Optional common fields
    ApplyMethod? apply,
    String? regex,
    int? regexGroup,
    String? regexReplace,
    String? regexReplaceWith,
    Map<String, String>? replaceFirst,
    Map<String, String>? replaceAll,
    int? cropStart,
    int? cropEnd,
    String? prepend,
    String? append,
    List<Object>? match,
    int? nth,
    String? splitBy,
    List<TransformationType>? transformationOrder,
  }) {
    return Optional._(
      keys: keys,
      values: values,
      apply: apply,
      regex: regex,
      regexGroup: regexGroup,
      regexReplace: regexReplace,
      regexReplaceWith: regexReplaceWith,
      replaceFirst: replaceFirst,
      replaceAll: replaceAll,
      cropStart: cropStart,
      cropEnd: cropEnd,
      prepend: prepend,
      append: append,
      match: match,
      nth: nth,
      splitBy: splitBy,
      transformationOrder: transformationOrder,
    );
  }

  /// Named constructor for StaticVal-specific optional parameters
  factory Optional.staticVal({
    String? strVal,
    Map<String, Object>? mapVal,
    // Optional common fields
    ApplyMethod? apply,
    String? regex,
    int? regexGroup,
    String? regexReplace,
    String? regexReplaceWith,
    Map<String, String>? replaceFirst,
    Map<String, String>? replaceAll,
    int? cropStart,
    int? cropEnd,
    String? prepend,
    String? append,
    List<Object>? match,
    int? nth,
    String? splitBy,
    List<TransformationType>? transformationOrder,
  }) {
    return Optional._(
      strVal: strVal,
      mapVal: mapVal,
      apply: apply,
      regex: regex,
      regexGroup: regexGroup,
      regexReplace: regexReplace,
      regexReplaceWith: regexReplaceWith,
      replaceFirst: replaceFirst,
      replaceAll: replaceAll,
      cropStart: cropStart,
      cropEnd: cropEnd,
      prepend: prepend,
      append: append,
      match: match,
      nth: nth,
      splitBy: splitBy,
      transformationOrder: transformationOrder,
    );
  }

  /// Applies the relevant transformations based on the set fields and specified order
  Object applyTransformations(Object data, bool debug) {
    // Use specified transformation order or default order if not provided
    final List<TransformationType> order = transformationOrder ??
        [
          if (nth != null) TransformationType.nth,
          if (splitBy != null) TransformationType.splitBy,
          if (apply != null) TransformationType.apply,
          if (replaceFirst != null || replaceAll != null)
            TransformationType.replace,
          if (regexReplace != null || regexReplaceWith != null)
            TransformationType.regexReplace,
          if (regex != null || regexGroup != null)
            TransformationType.regexMatch,
          if (cropStart != null) TransformationType.cropStart,
          if (cropEnd != null) TransformationType.cropEnd,
          if (prepend != null) TransformationType.prepend,
          if (append != null) TransformationType.append,
          if (match != null) TransformationType.match,
        ];

    for (final TransformationType transformation in order) {
      switch (transformation) {
        case TransformationType.nth:
          final result = _nth(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.splitBy:
          final result = _splitBy(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.apply:
          final result = _apply(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.replace:
          final result = _replace(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.regexReplace:
          final result = _regexReplace(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.regexMatch:
          final result = _regexMatch(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.cropStart:
          final result = _cropStart(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.cropEnd:
          final result = _cropEnd(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.prepend:
          final result = _prepend(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.append:
          final result = _append(data, debug);
          if (result != null) {
            data = result;
          }
          break;

        case TransformationType.match:
          final result = _match(data, debug);
          if (result != null) {
            data = result;
          }
          break;
      }
    }

    return data;
  }

  /// Transformation: nth
  Object? _nth(Object data, bool debug) {
    if (nth == null || data is! List) return null;
    if (nth! < 0 || nth! >= data.length) return null;
    return data[nth!];
  }

  /// Transformation: splitBy
  Object? _splitBy(Object data, bool debug) {
    if (splitBy == null || data is! String) return null;
    if (!data.contains(splitBy!)) return null;
    return data.split(splitBy!);
  }

  /// Transformation: apply
  Object? _apply(Object data, bool debug) {
    if (apply == null) return null;

    switch (apply!) {
      case ApplyMethod.urldecode:
        return Uri.decodeFull(data.toString());
      case ApplyMethod.mapToList:
        if (data is Map) {
          return data.values.toList();
        }
        break;
    }
    return null;
  }

  /// Transformation: replace
  Object? _replace(Object data, bool debug) {
    if ((replaceFirst == null && replaceAll == null) ||
        data is! String && data is! List) {
      return null;
    }

    if (data is String) {
      return _replaceInString(data);
    } else if (data is List) {
      return _replaceInList(data);
    }
    return null;
  }

  /// Helper for replacing in strings
  String _replaceInString(String data) {
    String result = data;
    if (replaceFirst != null) {
      for (final entry in replaceFirst!.entries) {
        result = result.replaceFirst(entry.key, entry.value);
      }
    }
    if (replaceAll != null) {
      for (final entry in replaceAll!.entries) {
        result = result.replaceAll(entry.key, entry.value);
      }
    }
    return result;
  }

  /// Helper for replacing in lists
  List<String> _replaceInList(List data) {
    final List<String> result = [];
    for (final item in data) {
      String temp = item.toString();
      if (replaceFirst != null) {
        for (final entry in replaceFirst!.entries) {
          temp = temp.replaceFirst(entry.key, entry.value);
        }
      }
      if (replaceAll != null) {
        for (final entry in replaceAll!.entries) {
          temp = temp.replaceAll(entry.key, entry.value);
        }
      }
      result.add(temp);
    }
    return result;
  }

  /// Transformation: regexReplace
  Object? _regexReplace(Object data, bool debug) {
    if (_regexReplaceRegExp == null || data is! String && data is! List) {
      return null;
    }
    final String replaceWith = regexReplaceWith ?? '';

    if (data is String) {
      final String sanitized =
          data.replaceAll(_regexReplaceRegExp!, replaceWith).trim();
      return sanitized.isNotEmpty ? sanitized : null;
    } else if (data is List) {
      final List<String> sanitizedList = [];
      for (final item in data) {
        final String sanitized = item
            .toString()
            .replaceAll(_regexReplaceRegExp!, replaceWith)
            .trim();
        if (sanitized.isNotEmpty) {
          sanitizedList.add(sanitized);
        }
      }
      return sanitizedList.isNotEmpty ? sanitizedList : null;
    }
    return null;
  }

  /// Transformation: regexMatch
  Object? _regexMatch(Object data, bool debug) {
    if (_regex == null || data is! String) return null;
    return _regex!.hasMatch(data)
        ? _regex!.firstMatch(data)!.group(regexGroup ?? 0)
        : null;
  }

  /// Transformation: cropStart
  Object? _cropStart(Object data, bool debug) {
    if (cropStart == null) return null;

    if (data is String) {
      if (cropStart! <= data.length && cropStart! > 0) {
        return data.substring(cropStart!).trim();
      }
    } else if (data is List) {
      if (cropStart! <= data.length && cropStart! > 0) {
        return data.sublist(cropStart!);
      }
    }
    return null;
  }

  /// Transformation: cropEnd
  Object? _cropEnd(Object data, bool debug) {
    if (cropEnd == null) return null;

    if (data is String) {
      if (cropEnd! <= data.length && cropEnd! > 0) {
        return data.substring(0, data.length - cropEnd!).trim();
      }
    } else if (data is List) {
      if (cropEnd! <= data.length && cropEnd! > 0) {
        return data.sublist(0, data.length - cropEnd!);
      }
    }
    return null;
  }

  /// Transformation: prepend
  Object? _prepend(Object data, bool debug) {
    if (prepend == null) return null;

    if (data is String) {
      return prepend! + data;
    } else if (data is List) {
      return data.map((item) => prepend! + item.toString()).toList();
    }
    return null;
  }

  /// Transformation: append
  Object? _append(Object data, bool debug) {
    if (append == null) return null;

    if (data is String) {
      return data + append!;
    } else if (data is List) {
      return data.map((item) => item.toString() + append!).toList();
    }
    return null;
  }

  /// Transformation: match
  Object? _match(Object data, bool debug) {
    if (match == null || data is! String) return null;

    for (final m in match!) {
      if (data.trim().contains(m.toString().trim())) {
        return true;
      }
    }
    return false;
  }
}
