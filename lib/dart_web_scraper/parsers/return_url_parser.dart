import 'package:dart_web_scraper/dart_web_scraper.dart';

/// Returns the URL from parent data as a Data object
/// Simple utility parser that extracts the URL itself
Data? returnUrlParser({
  required Parser parser,
  required Data parentData,
  required bool debug,
}) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Return URL", debug, color: LogColor.cyan);
  return Data(parentData.url, parentData.url.toString());
}
