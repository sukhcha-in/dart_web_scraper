import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? returnUrlParser(Parser parser, Data parentData, bool debug) {
  printLog("----------------------------------", debug, color: LogColor.yellow);
  printLog("ID: ${parser.id} Parser: Return URL", debug, color: LogColor.cyan);
  return Data(parentData.url, parentData.url.toString());
}
