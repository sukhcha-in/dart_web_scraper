import 'package:dart_web_scraper/dart_web_scraper.dart';

class AbstractOptional {
  /// Apply different functions to result.
  ApplyMethod? apply;

  /// Regex pattern.
  String? regex;

  /// Match to group.
  int? regexGroup;

  /// Regex Replace pattern.
  String? regexReplace;

  /// Replace with selected pattern.
  String? regexReplaceWith;

  /// Map to find keys and replace them with values.
  Map<String, String>? replaceFirst;

  /// Map to find keys and replace all of them with values.
  Map<String, String>? replaceAll;

  /// Crop result from start.
  int? cropStart;

  /// Crop result from end.
  int? cropEnd;

  /// Prepend string to result.
  String? prepend;

  /// Append string to result.
  String? append;

  /// Checks if result has match in predefined list.
  List<Object>? match;

  /// Select nth result from list.
  int? nth;

  /// Select nth result from list.
  String? splitBy;

  ///
  /// Based on ParserType.
  ///

  ///? [ParserType.http].
  /// Target URL.
  /// URLs can have [<slot></slot>] where parent value will be inserted.
  String? url;

  /// HttpMethod as GET/POST.
  HttpMethod? method;

  /// Add Custom Headers.
  Map<String, Object>? headers;

  /// Custom User Agent.
  UserAgentDevice? userAgent;

  /// responseType defines what to do once we grab data from URL.
  /// if [HttpResponseType.html] then result will be converted to element.
  /// if [HttpResponseType.json] then result will be decoded from JSON.
  HttpResponseType? responseType;

  /// For POST requests you can add custom payLoad.
  Object? payLoad;

  /// payLoad can be String or JSON.
  HttpPayload? payloadType;

  /// Use passed proxy.
  bool usePassedProxy;

  /// Cache response?
  bool cacheResponse;

  ///* [ParserType.strBetween].
  /// Start of a string.
  String? start;

  /// End of a string.
  String? end;

  ///* [ParserType.sibling].
  /// If where is passed, value of selector is matched, result is sibling of an element where match was found.
  List<String>? where;

  /// Sibling direction [previous] or [next]
  SiblingDirection? siblingDirection;

  ///* [ParserType.json].
  /// JSON Table keys path.
  String? keys;

  /// JSON Table values path.
  String? values;

  ///* [ParserType.staticVal].
  String? strVal;
  Map<String, Object>? mapVal;

  AbstractOptional({
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
    this.start,
    this.end,
    this.where,
    this.siblingDirection,
    this.keys,
    this.values,
    this.strVal,
    this.mapVal,
  });
}

class Optional extends AbstractOptional {
  Optional({
    super.apply,
    super.regex,
    super.regexGroup,
    super.regexReplace,
    super.regexReplaceWith,
    super.replaceFirst,
    super.replaceAll,
    super.cropStart,
    super.cropEnd,
    super.prepend,
    super.append,
    super.match,
    super.nth,
    super.splitBy,
  });
}

class HttpOptional extends AbstractOptional {
  HttpOptional({
    super.url,
    super.method,
    super.headers,
    super.userAgent,
    super.responseType,
    Object? payload,
    super.usePassedProxy,
    super.payloadType,
    super.cacheResponse,
  }) : super(payLoad: payload);
}

class StrBtwOptional extends AbstractOptional {
  StrBtwOptional({
    super.start,
    super.end,
  });
}

class SiblingOptional extends AbstractOptional {
  SiblingOptional({
    required SiblingDirection direction,
    super.where,
  }) : super(siblingDirection: direction);
}

class TableOptional extends AbstractOptional {
  TableOptional({
    super.keys,
    super.values,
  });
}

class StaticOptional extends AbstractOptional {
  StaticOptional({
    super.strVal,
    super.mapVal,
  });
}
