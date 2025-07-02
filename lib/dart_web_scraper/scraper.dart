import 'package:dart_web_scraper/common/utils/cookie_utils.dart';
import 'package:dart_web_scraper/common/utils/http.dart';
import 'package:dart_web_scraper/common/utils/random.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// Used for scraping HTML data from the web.
class Scraper {
  Future<Data> scrape({
    required Uri url,
    required ScraperConfig scraperConfig,
    Document? html,
    Map<String, String>? cookies,
    String? userAgent,
    Map<String, Object>? headers,
    ProxyAPIConfig? proxyAPIConfig,
    bool debug = false,
  }) async {
    /// Build headers
    printLog('Scraper: Building headers...', debug, color: LogColor.blue);
    Map<String, String> headersMerged = {
      "Accept-Language": "en-US,en",
    };

    /// User-Agent
    /// If `userAgent` is defined
    if (userAgent != null) {
      printLog(
        'Scraper: Using user-passed User-Agent...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['User-Agent'] = userAgent;
    }

    /// If `userAgent` is not defined, let's generate one based on our config
    if (!headersMerged.containsKey("User-Agent")) {
      printLog(
        'Scraper: Generating random User-Agent...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['User-Agent'] = randomUserAgent(scraperConfig.userAgent);
    }

    /// Cookie
    /// If `cookies` variable is defined
    if (cookies != null) {
      printLog(
        'Scraper: Using user-passed cookies...',
        debug,
        color: LogColor.blue,
      );
      headersMerged['Cookie'] = mapToCookie(cookies);
    }

    if (headers != null) {
      headers.forEach((key, value) {
        headersMerged[key] = value.toString();
      });
    }

    /// Print headers
    printLog('Scraper: Headers: $headersMerged', debug, color: LogColor.blue);

    /// Clean the URL based on cleaner defined in config
    printLog('Scraper: Cleaning URL...', debug, color: LogColor.blue);
    url = cleanScraperConfigUrl(url, scraperConfig.urlCleaner);
    printLog("Scraper: Cleaned URL :) $url", debug, color: LogColor.green);

    Data dom = Data(url, "");
    printLog(
      'Scraper: Checking if target needs html...',
      debug,
      color: LogColor.blue,
    );
    if (scraperConfig.requiresHtml) {
      printLog('Scraper: Target needs html!!!', debug, color: LogColor.blue);
      String? requestData;
      if (scraperConfig.forceRefresh) {
        printLog(
          'Scraper: Forcing http request for new html!!!',
          debug,
          color: LogColor.blue,
        );
        requestData = await getRequest(
          url,
          headers: headersMerged,
          debug: debug,
          proxyAPIConfig: proxyAPIConfig,
        );
      } else if (html != null && html.hasContent()) {
        printLog(
          'Scraper: Using user-passed html :)',
          debug,
          color: LogColor.orange,
        );
        dom = Data(url, html);
      } else {
        printLog('Scraper: Fetching html...', debug, color: LogColor.blue);
        requestData = await getRequest(
          url,
          headers: headersMerged,
          debug: debug,
          proxyAPIConfig: proxyAPIConfig,
        );
      }
      if (dom.obj != "") {
        printLog('Scraper: HTML fetched :)', debug, color: LogColor.green);
      } else if (requestData != null) {
        printLog('Scraper: HTML fetched :)', debug, color: LogColor.green);
        dom = Data(url, parse(requestData));
      } else {
        printLog(
          'Scraper: Unable to fetch data!',
          debug,
          color: LogColor.red,
        );
        throw WebScraperError('Unable to fetch data!');
      }
    } else {
      printLog(
        'Scraper: Target does not need html. Skipping...',
        debug,
        color: LogColor.orange,
      );
    }

    printLog('Scraper: Returning data...', debug, color: LogColor.green);
    return dom;
  }
}
