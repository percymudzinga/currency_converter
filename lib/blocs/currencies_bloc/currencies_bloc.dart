import 'package:bloc/bloc.dart';
import 'package:currency_converter/blocs/saved_currencies_bloc/saved_currencies_bloc.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:currency_converter/models/currency_rates_response.dart';
import 'package:currency_converter/repositories/currencies_repository.dart';
import 'package:equatable/equatable.dart';

part 'currencies_event.dart';
part 'currencies_state.dart';

class CurrenciesBloc extends Bloc<CurrenciesEvent, CurrenciesState> {
  final CurrenciesRepository currenciesRepository;
  final SavedCurrenciesBloc savedCurrenciesBloc;
  CurrenciesBloc({
    required this.currenciesRepository,
    required this.savedCurrenciesBloc,
  }) : super(CurrenciesInitial()) {
    on<LoadCurrencies>((event, emit) async {
      var cachedCurrencies = await currenciesRepository.getCurrencies();
      emit(CurrenciesLoaded(currencies: cachedCurrencies));
      var monitoredCurrencies = cachedCurrencies.where((element) => element.isMonitored).toList();
      _updateMonitoredCurrenciesBloc(monitoredCurrencies);
      var currenciesMap = await currenciesRepository.loadCurrenciesFromServer();
      var rates = await currenciesRepository.getCurrencyRates();
      var currencies = await _cacheCurrencies(currenciesMap, rates, monitoredCurrencies);
      emit(CurrenciesLoaded(currencies: currencies));
    });
  }

  Future<List<Currency>> _cacheCurrencies(
    Map<String, dynamic> currenciesMap,
    CurrencyRatesResponse rates,
    List<Currency> monitoredCurrencies,
  ) async {
    var currencies = <Currency>[];
    currenciesMap.forEach((key, value) {
      var rate = rates.rates[key];

      if (rate != null) {
        currencies.add(
          Currency(
            code: key,
            name: value,
            rate: rate,
            isBase: key == rates.base,
            isMonitored: monitoredCurrencies.where((element) => element.code == key).isNotEmpty,
          ),
        );
      }
    });
    await currenciesRepository.saveCurrenciesToLocal(currencies);
    return currencies;
  }

  _updateMonitoredCurrenciesBloc(List<Currency> currencies) {
    savedCurrenciesBloc.add(
      LoadSavedCurrencies(
        currencies: currencies,
      ),
    );
  }
}
