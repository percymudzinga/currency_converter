class AppUrls {
  static const String _baseUrl = 'https://openexchangerates.org/api';
  static const _appId = String.fromEnvironment('APP_ID');

  static const String currencies = '$_baseUrl/currencies.json';
  static const String rates = '$_baseUrl/latest.json?app_id=$_appId';
}
