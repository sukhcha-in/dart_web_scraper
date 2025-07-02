/// Dart Web Scraper Library
///
/// A comprehensive web scraping library for Dart that provides tools for extracting
/// data from web pages using configurable parsers and transformations.
///
/// This library exports all the core components needed to build web scrapers:
/// - Core scraping and parsing classes
/// - Data models for configuration and results
/// - Utility functions and enums
/// - Debug and logging utilities

library;

/// Core scraping and parsing classes
///
/// These are the main classes you'll interact with to perform web scraping:
/// - [WebScraper]: High-level class that combines scraping and parsing
/// - [Scraper]: Handles HTTP requests and HTML fetching
/// - [WebParser]: Processes scraped HTML using configurable parsers
export 'dart_web_scraper/scraper.dart';
export 'dart_web_scraper/web_parser.dart';
export 'dart_web_scraper/web_scraper.dart';

/// Data models for configuration and results
///
/// These models define the structure for:
/// - [ScraperConfig]: Configuration for targeting specific URLs and defining parsers
/// - [Parser]: Individual parser configuration for extracting specific data
/// - [Data]: Container for scraped data with URL and content
/// - [ErrorModel]: Error handling and reporting
/// - [TransformationOptions]: Data transformation and cleaning options
/// - [ParserOptions]: Parser-specific configuration options
/// - [UrlCleaner]: URL preprocessing and cleaning utilities
/// - [ProxyAPIConfig]: Configuration for routing HTTP requests through a proxy API
export 'common/models/error_model.dart';
export 'common/models/url_cleaner_model.dart';
export 'common/models/transformation_options_model.dart';
export 'common/models/parser_options_model.dart';
export 'common/models/parser_model.dart';
export 'common/models/transformations/replace_transformation.dart';
export 'common/models/scraper_config_model.dart';
export 'common/models/data_model.dart';
export 'common/models/proxy_api_model.dart';
export 'common/models/parser_options/http_parser_options.dart';
export 'common/models/parser_options/table_parser_options.dart';
export 'common/models/parser_options/sibling_parser_options.dart';
export 'common/models/parser_options/static_value_parser_options.dart';
export 'common/models/parser_options/string_between_parser_options.dart';
export 'common/models/parser_options/url_param_parser_options.dart';

/// Enums and constants
///
/// Defines various enums used throughout the library:
/// - [ParserType]: Types of parsers (element, text, image, etc.)
/// - [UserAgentDevice]: Device types for user agent selection
/// - [HttpMethod]: HTTP request methods
/// - [LogColor]: Colors for debug logging
export 'common/enums.dart';

/// Utility functions and helpers
///
/// Provides utility functions for:
/// - [WebScraperUtils]: General web scraping utilities
/// - [Logger]: Debug logging and output formatting
/// - [CleanerRegistry]: Registry for custom data cleaning functions
export 'common/utils/webscraper_utils.dart';
export 'common/utils/debug/logger.dart';
export 'common/utils/cleaner_registry.dart';
