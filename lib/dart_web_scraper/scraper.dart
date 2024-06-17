import 'dart:io';
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
    required Config config,
    Document? html,
    Map<String, String>? cookies,
    String? userAgent,
    Uri? proxyUrl,
    bool debug = false,
  }) async {
    /// Fetch target
    UrlTarget? target = fetchTarget(config.urlTargets, url);
    if (target == null) {
      printLog('Scraper: Target not found!', debug, color: LogColor.red);
      throw SpiderError('Unsupported URL');
    } else {
      printLog('Scraper: Target found!', debug, color: LogColor.green);
    }

    /// Build headers
    printLog('Scraper: Building headers...', debug, color: LogColor.blue);
    Map<String, String> headers = {
      "Accept-Language": "en-US,en",
    };

    /// User-Agent
    /// If `userAgent` is defined and config allows passing custom userAgent
    if (userAgent != null && config.usePassedUserAgent) {
      printLog(
        'Scraper: Using user-passed User-Agent...',
        debug,
        color: LogColor.blue,
      );
      headers.addAll({
        HttpHeaders.userAgentHeader: userAgent,
      });
    }

    /// If `userAgent` is not defined, let's generate one based on our config
    if (!headers.containsKey("user-agent")) {
      printLog(
        'Scraper: Generating random User-Agent...',
        debug,
        color: LogColor.blue,
      );
      headers.addAll({
        HttpHeaders.userAgentHeader: randomUserAgent(config.userAgent),
      });
    }

    /// Cookie
    /// If `cookies` variable is defined and config allows using custom cookies
    if (cookies != null && config.usePassedCookies) {
      printLog(
        'Scraper: Using user-passed cookies...',
        debug,
        color: LogColor.blue,
      );
      headers.addAll({
        "cookie": mapToCookie(cookies),
      });
    }

    /// Clean the URL based on cleaner defined in config
    printLog('Scraper: Cleaning URL...', debug, color: LogColor.blue);
    url = cleanConfigUrl(url, target.urlCleaner);
    printLog("Scraper: Cleaned URL :) $url", debug, color: LogColor.green);

    Data dom = Data(url, "");
    printLog(
      'Scraper: Checking if target needs html...',
      debug,
      color: LogColor.blue,
    );
    if (target.needsHtml) {
      printLog('Scraper: Target needs html!!!', debug, color: LogColor.blue);
      String? requestData;
      if (config.forceFetch) {
        printLog(
          'Scraper: Forcing http request for new html!!!',
          debug,
          color: LogColor.blue,
        );
        requestData = await getRequest(
          url,
          headers: headers,
          debug: debug,
          proxyUrl: proxyUrl,
        );
      } else if (config.usePassedHtml && html != null && html.hasContent()) {
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
          headers: headers,
          debug: debug,
          proxyUrl: proxyUrl,
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
        throw SpiderError('Unable to fetch data!');
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
