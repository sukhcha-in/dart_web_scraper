import 'package:dart_web_scraper/dart_web_scraper.dart';

Data? returnUrlParser(Parser parser, Data parentData) {
  return Data(parentData.url, parentData.url.toString());
}
