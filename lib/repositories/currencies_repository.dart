import 'dart:convert';

import 'package:currency_converter/constants/app_urls.dart';
import 'package:currency_converter/constants/hive_constants.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:currency_converter/models/currency_rates_response.dart';
import 'package:currency_converter/utils/http_utils.dart';
import 'package:hive/hive.dart';

import '../exceptions/api_exception.dart';

class CurrenciesRepository {
  final HiveInterface hive;

  CurrenciesRepository({required this.hive});
  List<Currency> getCurrencies() {
    var box = hive.box<Currency>(HiveConstants.currencies);
    return box.values.toList();
  }

  Future<Map<String, dynamic>> loadCurrenciesFromServer() async {
    var response = await HttpUtils.instance.get(Uri.parse(AppUrls.currencies));
    if (response.status == Status.failure) {
      throw ApiException(response.data);
    }
    return jsonDecode(response.data);
  }

  Future<CurrencyRatesResponse> getCurrencyRates() async {
    var response = await HttpUtils.instance.get(Uri.parse(AppUrls.rates));
    if (response.status == Status.failure) {
      throw ApiException(response.data);
    }
    return CurrencyRatesResponse.fromJson(jsonDecode(response.data));
  }

  saveCurrencyToDb(Currency currency) async {
    var box = hive.box<Currency>('currencies');
    await box.put(currency.code, currency.copyWith(isMonitored: true));
  }

  Future saveCurrenciesToLocal(List<Currency> currencies) async {
    var box = hive.box<Currency>(HiveConstants.currencies);
    await box.clear();
    for (var currency in currencies) {
      await box.put(currency.code, currency);
    }
  }

  Future deleteCurrency(Currency currency) async {
    var box = hive.box<Currency>(HiveConstants.currencies);
    await box.put(currency.code, currency.copyWith(isMonitored: false));
  }
}
