import 'dart:convert';

import 'package:dart_web_scraper/common/models/transformations/crop_transformation.dart';
import 'package:dart_web_scraper/common/models/transformations/regex_replace_transformation.dart';
import 'package:dart_web_scraper/common/models/transformations/regex_transformation.dart';
import 'package:dart_web_scraper/common/models/transformations/replace_transformation.dart';

import '../utils/webscraper_utils.dart';

/// Types of transformations that can be applied to extracted data.
///
/// Each transformation type represents a different way to modify or process
/// the data after it has been extracted by a parser.
enum TransformationType {
  /// Extract the nth item from a list
  nth,

  /// Split data by a delimiter
  splitBy,

  /// Decode URL-encoded strings
  urldecode,

  /// Convert map values to a list
  mapToList,

  /// Replace text or values
  replace,

  /// Replace text using regular expressions
  regexReplace,

  /// Extract text using regular expressions
  regexMatch,

  /// Remove characters from the start or end
  crop,

  /// Add text to the beginning
  prepend,

  /// Add text to the end
  append,

  /// Check if data matches any value in a list
  match,
}

/// Configuration for applying multiple transformations to extracted data.
///
/// This class provides a comprehensive set of data transformation options
/// that can be applied to parser results. Transformations are applied in
/// a specific order to ensure consistent results.
///
/// Available transformations include:
/// - Text manipulation (replace, regex, crop, prepend, append)
/// - Data structure operations (nth, splitBy, urldecode, mapToList)
/// - Content validation (match)
/// - Specialized transformations (HTTP requests, table processing, etc.)
class TransformationOptions {
  /// Common transformation fields for basic operations
  final String? prepend;
  final String? append;
  final List<Object>? match;
  final int? nth;
  final String? splitBy;
  final bool? urldecode;
  final bool? mapToList;

  /// Dedicated transformation objects for complex operations
  final RegexTransformationOptions? regexMatch;
  final RegexReplaceTransformationOptions? regexReplace;
  final ReplaceTransformationOptions? replace;
  final CropTransformationOptions? crop;

  /// The order in which transformations should be applied
  ///
  /// If not specified, transformations are applied in a logical order:
  /// 1. nth (extract specific item)
  /// 2. splitBy (split data)
  /// 3. urldecode (decode URL-encoded strings)
  /// 4. mapToList (convert map to list)
  /// 5. replace (text replacement)
  /// 6. regexReplace (regex-based replacement)
  /// 7. regexMatch (regex extraction)
  /// 8. crop (trimming)
  /// 9. prepend/append (adding text)
  /// 10. match (validation)
  final List<TransformationType>? transformationOrder;

  /// Precompiled RegExp patterns for performance optimization
  RegExp? _regexPattern;
  RegExp? _regexReplacePattern;

  /// Creates a new TransformationOptions instance.
  ///
  /// Parameters:
  /// - [prepend]: Text to add to the beginning
  /// - [append]: Text to add to the end
  /// - [match]: List of values to check for matches
  /// - [nth]: Index to extract from a list (negative for reverse indexing)
  /// - [splitBy]: Delimiter to split data by
  /// - [urldecode]: Whether to decode URL-encoded strings
  /// - [mapToList]: Whether to convert map values to a list
  /// - [regexMatch]: Regular expression extraction options
  /// - [regexReplace]: Regular expression replacement options
  /// - [replace]: Text replacement options
  /// - [crop]: Text cropping options (start/end)
  /// - [transformationOrder]: Custom order for applying transformations
  TransformationOptions({
    this.prepend,
    this.append,
    this.match,
    this.nth,
    this.splitBy,
    this.urldecode,
    this.mapToList,
    this.regexMatch,
    this.regexReplace,
    this.replace,
    this.crop,
    this.transformationOrder,
  }) {
    _compileRegex();
  }

  /// Compiles regular expression patterns for performance.
  ///
  /// This method precompiles regex patterns to avoid repeated compilation
  /// during transformation application.
  void _compileRegex() {
    if (regexMatch != null) {
      _regexPattern = RegExp(regexMatch!.regex);
    }
    if (regexReplace != null) {
      _regexReplacePattern = RegExp(regexReplace!.regexReplace);
    }
  }

  /// Applies all configured transformations to the input data.
  ///
  /// This method processes the data through all enabled transformations
  /// in the specified order (or default order if not specified).
  ///
  /// Parameters:
  /// - [data]: The data to transform (String, List, or other types)
  /// - [debug]: Enable debug logging for transformation steps
  ///
  /// Returns:
  /// - Transformed data, or null if any transformation fails
  Object? applyTransformations(
      Object data, Map<String, Object> allData, bool debug) {
    /// Determine the order of transformations to apply
    final List<TransformationType> order = transformationOrder ??
        [
          if (nth != null) TransformationType.nth,
          if (splitBy != null) TransformationType.splitBy,
          if (urldecode == true) TransformationType.urldecode,
          if (mapToList == true) TransformationType.mapToList,
          if (replace != null) TransformationType.replace,
          if (regexReplace != null) TransformationType.regexReplace,
          if (regexMatch != null) TransformationType.regexMatch,
          if (crop != null) TransformationType.crop,
          if (prepend != null) TransformationType.prepend,
          if (append != null) TransformationType.append,
          if (match != null) TransformationType.match,
        ];

    /// Apply each transformation in order
    for (final TransformationType transformation in order) {
      switch (transformation) {
        case TransformationType.nth:
          final result = _nth(data, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.splitBy:
          final result = _splitBy(data, allData, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.urldecode:
          final result = _urldecode(data, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.mapToList:
          final result = _mapToList(data, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.replace:
          final result = _replace(data, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.regexReplace:
          final result = _regexReplace(data, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.regexMatch:
          final result = _regexMatch(data, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.crop:
          final result = _crop(data, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.prepend:
          final result = _prepend(data, allData, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.append:
          final result = _append(data, allData, debug);
          if (result == null) return null;
          data = result;
          break;

        case TransformationType.match:
          final result = _match(data, allData, debug);
          if (result == null) return null;
          data = result;
          break;
      }
    }

    return data;
  }

  /// Extracts the nth item from a list.
  ///
  /// Supports negative indexing (e.g., -1 for last item).
  ///
  /// Parameters:
  /// - [data]: List data to extract from
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - The nth item, or null if index is out of bounds
  Object? _nth(Object data, bool debug) {
    if (nth == null || data is! List) return null;

    int index = nth!;
    int len = data.length;
    index = index < 0 ? len + index : index;

    return (index >= 0 && index < len) ? data[index] : null;
  }

  /// Splits data by a delimiter.
  ///
  /// Parameters:
  /// - [data]: String data to split
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - List of split items, or null if delimiter not found
  Object? _splitBy(Object data, Map<String, Object> allData, bool debug) {
    if (splitBy == null || data is! String) return null;
    final injectedsplitBy = _injectSlot(splitBy!, allData, debug);

    if (!data.contains(injectedsplitBy)) return null;
    return data.split(injectedsplitBy);
  }

  /// Decodes URL-encoded strings.
  ///
  /// Parameters:
  /// - [data]: String data to decode
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - Decoded string, or null if decoding fails
  Object? _urldecode(Object data, bool debug) {
    if (urldecode != true || data is! String) return null;

    return Uri.decodeFull(data);
  }

  /// Converts map values to a list.
  ///
  /// Parameters:
  /// - [data]: Map data to convert
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - List of map values, or null if conversion fails
  Object? _mapToList(Object data, bool debug) {
    if (mapToList != true || data is! Map) return null;

    return data.values.toList();
  }

  /// Replaces text or values in the data.
  ///
  /// Supports both string and list data types. Can perform first-only
  /// or all-occurrence replacements.
  ///
  /// Parameters:
  /// - [data]: Data to replace text in
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - Data with replacements applied, or null if replacement fails
  Object? _replace(Object data, bool debug) {
    if (replace == null || (data is! String && data is! List)) {
      return null;
    }

    if (data is String) {
      return _replaceInString(data);
    } else if (data is List) {
      return _replaceInList(data);
    }
    return null;
  }

  /// Helper method for replacing text in strings.
  ///
  /// Applies nth and all-occurrence replacements.
  ///
  /// Parameters:4
  /// - [data]: String to replace text in
  ///
  /// Returns:
  /// - String with replacements applied
  String _replaceInString(String data) {
    String result = data;
    if (replace!.replaceFirst != null) {
      for (final entry in replace!.replaceFirst!.entries) {
        result = result.replaceFirst(entry.key, entry.value);
      }
    }
    if (replace!.replaceAll != null) {
      for (final entry in replace!.replaceAll!.entries) {
        result = result.replaceAll(entry.key, entry.value);
      }
    }
    return result;
  }

  /// Helper method for replacing text in lists.
  ///
  /// Applies replacements to each item in the list.
  ///
  /// Parameters:
  /// - [data]: List to replace text in
  ///
  /// Returns:
  /// - List with replacements applied to each item
  List<String> _replaceInList(List data) {
    final List<String> result = [];
    for (final item in data) {
      String temp = item.toString();
      if (replace!.replaceFirst != null) {
        for (final entry in replace!.replaceFirst!.entries) {
          temp = temp.replaceFirst(entry.key, entry.value);
        }
      }
      if (replace!.replaceAll != null) {
        for (final entry in replace!.replaceAll!.entries) {
          temp = temp.replaceAll(entry.key, entry.value);
        }
      }
      result.add(temp);
    }
    return result;
  }

  /// Replaces text using regular expressions.
  ///
  /// Uses a precompiled regex pattern for performance. Supports both
  /// string and list data types.
  ///
  /// Parameters:
  /// - [data]: Data to apply regex replacement to
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - Data with regex replacements applied, or null if replacement fails
  Object? _regexReplace(Object data, bool debug) {
    if (_regexReplacePattern == null ||
        regexReplace == null ||
        (data is! String && data is! List)) {
      return null;
    }
    final String replaceWith = regexReplace!.regexReplaceWith;

    if (data is String) {
      final String sanitized =
          data.replaceAll(_regexReplacePattern!, replaceWith).trim();
      return sanitized.isNotEmpty ? sanitized : null;
    } else if (data is List) {
      final List<String> sanitizedList = [];
      for (final item in data) {
        final String sanitized = item
            .toString()
            .replaceAll(_regexReplacePattern!, replaceWith)
            .trim();
        if (sanitized.isNotEmpty) {
          sanitizedList.add(sanitized);
        }
      }
      return sanitizedList.isNotEmpty ? sanitizedList : null;
    }
    return null;
  }

  /// Extracts text using regular expressions.
  ///
  /// Uses a precompiled regex pattern for performance. Can extract
  /// specific capture groups from the regex match.
  ///
  /// Parameters:
  /// - [data]: Data to extract regex matches from
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - Extracted regex matches, or null if no matches found
  Object? _regexMatch(Object data, bool debug) {
    if (_regexPattern == null || regexMatch == null) return null;

    String? extractMatch(String s) =>
        _regexPattern!.firstMatch(s)?.group(regexMatch!.regexGroup ?? 0);

    if (data is String) {
      return extractMatch(data);
    } else if (data is List) {
      final results = <String?>[];
      for (final item in data) {
        final result = extractMatch(item.toString());
        if (result != null) results.add(result);
      }
      return results;
    }
    return null;
  }

  /// Removes characters from the start of the data.
  ///
  /// Supports both string and list data types. For strings, removes
  /// the specified number of characters from the beginning.
  ///
  /// Parameters:
  /// - [data]: Data to crop from the start
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - Cropped data, or null if cropping fails
  Object? _crop(Object data, bool debug) {
    if (crop?.cropStart == null && crop?.cropEnd == null) return null;

    final cropStart = crop?.cropStart;
    final cropEnd = crop?.cropEnd;

    if (data is String) {
      if (cropStart != null && cropStart <= data.length && cropStart > 0) {
        return data.substring(cropStart).trim();
      }
      if (cropEnd != null && cropEnd <= data.length && cropEnd > 0) {
        return data.substring(0, data.length - crop!.cropEnd!).trim();
      }
    } else if (data is List) {
      if (cropStart != null && cropStart <= data.length && cropStart > 0) {
        return data.sublist(cropStart);
      }
      if (cropEnd != null && cropEnd <= data.length && cropEnd > 0) {
        return data.sublist(0, data.length - cropEnd);
      }
    }
    return null;
  }

  /// Adds text to the beginning of the data.
  ///
  /// Supports both string and list data types. For lists, prepends
  /// the text to each item in the list.
  ///
  /// Parameters:
  /// - [data]: Data to prepend text to
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - Data with text prepended, or null if prepending fails
  Object? _prepend(Object data, Map<String, Object> allData, bool debug) {
    if (prepend == null) return null;
    final injectedPrepend = _injectSlot(prepend!, allData, debug);

    if (data is String) {
      return injectedPrepend + data;
    } else if (data is List) {
      return data.map((item) => injectedPrepend + item.toString()).toList();
    }
    return null;
  }

  /// Adds text to the end of the data.
  ///
  /// Supports both string and list data types. For lists, appends
  /// the text to each item in the list.
  ///
  /// Parameters:
  /// - [data]: Data to append text to
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - Data with text appended, or null if appending fails
  Object? _append(Object data, Map<String, Object> allData, bool debug) {
    if (append == null) return null;
    final injectedAppend = _injectSlot(append!, allData, debug);

    if (data is String) {
      return data + injectedAppend;
    } else if (data is List) {
      return data.map((item) => item.toString() + injectedAppend).toList();
    }
    return null;
  }

  /// Checks if the data matches any value in a list.
  ///
  /// Performs a case-insensitive substring match against each value
  /// in the match list. Returns true if any match is found.
  ///
  /// Parameters:
  /// - [data]: String data to check for matches
  /// - [debug]: Enable debug logging
  ///
  /// Returns:
  /// - True if a match is found, false otherwise, or null if checking fails
  Object? _match(Object data, Map<String, Object> allData, bool debug) {
    if (match == null || data is! String) return null;

    for (final m in match!) {
      final injectedMatch = _injectSlot(m.toString().trim(), allData, debug);
      if (data.trim().contains(injectedMatch)) {
        return true;
      }
    }
    return false;
  }

  String _injectSlot(String selector, Map<String, Object> allData, bool debug) {
    if (selector.contains("<slot>")) {
      selector = inject("slot", allData, selector);
    } else {
      selector = selector;
    }
    return selector;
  }

  /// Creates a TransformationOptions instance from a Map.
  ///
  /// This factory constructor is used for deserializing transformation
  /// configurations from JSON or other map-based formats.
  ///
  /// Parameters:
  /// - [map]: Map containing transformation configuration data
  ///
  /// Returns:
  /// - New TransformationOptions instance with data from the map
  factory TransformationOptions.fromMap(Map<String, dynamic> map) {
    return TransformationOptions(
      prepend: map['prepend'],
      append: map['append'],
      match: map['match'] != null ? List<Object>.from(map['match']) : null,
      nth: map['nth'],
      splitBy: map['splitBy'],
      urldecode: map['urldecode'] == true,
      mapToList: map['mapToList'] == true,
      regexMatch: map['regexMatch'] != null
          ? RegexTransformationOptions.fromMap(map['regexMatch'])
          : null,
      regexReplace: map['regexReplace'] != null
          ? RegexReplaceTransformationOptions.fromMap(map['regexReplace'])
          : null,
      replace: map['replace'] != null
          ? ReplaceTransformationOptions.fromMap(map['replace'])
          : null,
      crop: map['crop'] != null
          ? CropTransformationOptions.fromMap(map['crop'])
          : null,
      transformationOrder: map['transformationOrder'] != null
          ? (map['transformationOrder'] as List)
              .map((e) => TransformationType.values.firstWhere(
                    (t) => t.toString() == 'TransformationType.$e',
                  ))
              .toList()
          : null,
    );
  }

  /// Converts the TransformationOptions instance to a Map.
  ///
  /// This method is used for serializing the transformation configuration
  /// to JSON or other map-based formats.
  ///
  /// Returns:
  /// - Map containing all transformation configuration data
  Map<String, dynamic> toMap() {
    return {
      'prepend': prepend,
      'append': append,
      'match': match,
      'nth': nth,
      'splitBy': splitBy,
      'urldecode': urldecode,
      'mapToList': mapToList,
      'regexMatch': regexMatch?.toMap(),
      'regexReplace': regexReplace?.toMap(),
      'replace': replace?.toMap(),
      'crop': crop?.toMap(),
      'transformationOrder': transformationOrder
          ?.map((e) => e.toString().split('.').last)
          .toList(),
    };
  }

  /// Creates a TransformationOptions instance from a JSON string.
  factory TransformationOptions.fromJson(String json) {
    return TransformationOptions.fromMap(jsonDecode(json));
  }

  /// Converts the TransformationOptions instance to JSON string.
  String toJson() {
    return jsonEncode(toMap());
  }
}
