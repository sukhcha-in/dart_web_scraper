import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/parser.dart';

Map<String, List<Config>> configMap = {
  'example.com': testConfig,
};

List<Config> testConfig = [
  Config(
    usePassedUserAgent: true,
    parsers: {
      "main": [
        Parser(
          id: 'products',
          parent: ['_root'],
          type: ParserType.element,
          selector: ['div[role="listitem"]'],
          multiple: true,
        ),
        Parser(
          id: 'name',
          parent: ['products'],
          type: ParserType.text,
          selector: ['div.product'],
        ),
        Parser(
          id: 'sponsored',
          parent: ['products'],
          type: ParserType.attribute,
          selector: ['_self::data-component-type', '_self::class'],
          cleaner: (data, debug) {
            return data.obj == "sponsored" ? true : false;
          },
        )
      ],
    },
    urlTargets: [
      UrlTarget(
        name: 'main',
        where: [
          "/",
        ],
      ),
    ],
  ),
];

void main() async {
  Uri url = Uri.parse("https://example.com");

  Config? config = getConfig(
    url,
    configs: configMap,
  );
  if (config == null) {
    print("Unsupported URL");
    return;
  }

  WebParser webParser = WebParser();

  Map<String, Object> parsed = await webParser.parse(
    scrapedData: Data(
      url,
      parse(scrapedData),
    ),
    config: config,
    debug: true,
  );

  print(parsed);
}

String scrapedData = """
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Test</title>
</head>
<body>
    <div role="listitem" class="sponsored" data-component-type="sponsored">
        <div class="product">Product 1</div>
    </div>
    <div role="listitem" class="sponsored">
        <div class="product">Product 2</div>
    </div>
    <div role="listitem" data-component-type="sponsored">
        <div class="product">Product 3</div>
    </div>
    <div role="listitem">
        <div class="product">Product 4</div>
    </div>
</body>
</html>
""";
