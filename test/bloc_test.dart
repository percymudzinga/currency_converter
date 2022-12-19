import 'package:bloc_test/bloc_test.dart';
import 'package:currency_converter/blocs/currencies_bloc/currencies_bloc.dart';
import 'package:currency_converter/blocs/saved_currencies_bloc/saved_currencies_bloc.dart';
import 'package:currency_converter/blocs/selected_currency_bloc/selected_currency_bloc.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:currency_converter/repositories/currencies_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
@GenerateNiceMocks([MockSpec<CurrenciesRepository>()])
import 'bloc_test.mocks.dart';

class MockCurrenciesBloc extends MockBloc<CurrenciesEvent, CurrenciesState> implements CurrenciesBloc {}

class MockSavedCurrenciesBloc extends MockBloc<SavedCurrenciesEvent, SavedCurrenciesState> implements SavedCurrenciesBloc {}

var currencies = [
  Currency(
    code: 'USD',
    name: 'United States Dollar',
    rate: 1,
    isBase: true,
    isMonitored: false,
  ),
  Currency(
    code: 'ZAR',
    name: 'South African Rand',
    rate: 2,
    isBase: false,
    isMonitored: false,
  ),
];

void main() {
  currenciesBloc();
  savedCurrenciesBlocTests();
  selectedCurrencyBlocTest();
}

void currenciesBloc() {
  group('CurrenciesBloc', () {
    blocTest<CurrenciesBloc, CurrenciesState>(
      'emits [] when nothing is done state',
      build: () => CurrenciesBloc(
        savedCurrenciesBloc: MockSavedCurrenciesBloc(),
        currenciesRepository: MockCurrenciesRepository(),
      ),
      expect: () => [],
    );

    blocTest<CurrenciesBloc, CurrenciesState>(
      'emits CurrenciesLoaded state',
      build: () => CurrenciesBloc(
        savedCurrenciesBloc: MockSavedCurrenciesBloc(),
        currenciesRepository: MockCurrenciesRepository(),
      ),
      act: (bloc) => bloc.add(LoadCurrencies()),
      expect: () => [isA<CurrenciesLoaded>()],
    );
  });
}

void savedCurrenciesBlocTests() {
  group('SavedCurrenciesBloc', () {
    blocTest<SavedCurrenciesBloc, SavedCurrenciesState>(
      'emits [] when nothing is done state',
      build: () => SavedCurrenciesBloc(
        currenciesRepository: MockCurrenciesRepository(),
      ),
      expect: () => [],
    );

    blocTest<SavedCurrenciesBloc, SavedCurrenciesState>(
      'emits SavedCurrencies',
      build: () => SavedCurrenciesBloc(
        currenciesRepository: MockCurrenciesRepository(),
      ),
      act: (bloc) => bloc.add(
        const LoadSavedCurrencies(
          currencies: [],
        ),
      ),
      expect: () => [const SavedCurrencies([])],
    );

    blocTest<SavedCurrenciesBloc, SavedCurrenciesState>(
      'emits SavedCurrencies with currency',
      build: () => SavedCurrenciesBloc(
        currenciesRepository: MockCurrenciesRepository(),
      ),
      act: (bloc) => bloc.add(
        SaveCurrency(currencies.first),
      ),
      expect: () => [
        SavedCurrencies([currencies.first])
      ],
    );

    blocTest<SavedCurrenciesBloc, SavedCurrenciesState>(
      'emits SavedCurrencies with single currency and then with an empty array',
      build: () => SavedCurrenciesBloc(
        currenciesRepository: MockCurrenciesRepository(),
      ),
      act: (bloc) => bloc
        ..add(SaveCurrency(currencies.first))
        ..add(DeleteSavedCurrency(currencies.first)),
      expect: () => [
        SavedCurrencies([currencies.first]),
        const SavedCurrencies([])
      ],
    );
  });
}

void selectedCurrencyBlocTest() async {
  var currenciesBloc = MockCurrenciesBloc();
  whenListen(
    currenciesBloc,
    Stream<CurrenciesState>.fromIterable([CurrenciesLoaded(currencies: currencies)]),
    initialState: CurrenciesLoaded(currencies: currencies),
  );
  group('SelectedCurrencyBloc', () {
    blocTest(
      'Select a currency',
      build: () => SelectedCurrencyBloc(
        currenciesBloc: currenciesBloc,
      ),
      act: (bloc) => bloc.add(SelectCurrency(currency: currencies[1])),
      expect: () => [isA<SelectedCurrency>()],
    );

    blocTest(
      'Convert a currency from a base currency',
      build: () => SelectedCurrencyBloc(
        currenciesBloc: currenciesBloc,
      ),
      act: (bloc) => bloc
        ..add(
          SelectCurrency(currency: currencies[1]),
        )
        ..add(
          ConvertCurrency(2, currencies[0]),
        ),
      expect: () => [
        SelectedCurrency(currency: currencies[1], base: currencies[0]),
        SelectedCurrency(currency: currencies[1], base: currencies[0], baseAmount: 2.0, currencyAmount: 4.28),
      ],
    );

    blocTest(
      'Convert a currency from a selected currency',
      build: () => SelectedCurrencyBloc(
        currenciesBloc: currenciesBloc,
      ),
      act: (bloc) => bloc
        ..add(
          SelectCurrency(currency: currencies[1]),
        )
        ..add(
          ConvertCurrency(2, currencies[1]),
        ),
      expect: () => [
        SelectedCurrency(currency: currencies[1], base: currencies[0]),
        SelectedCurrency(currency: currencies[1], base: currencies[0], baseAmount: 1.07, currencyAmount: 2),
      ],
    );
  });
}
