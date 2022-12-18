import 'package:bloc/bloc.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:currency_converter/repositories/currencies_repository.dart';
import 'package:equatable/equatable.dart';

part 'saved_currencies_event.dart';
part 'saved_currencies_state.dart';

class SavedCurrenciesBloc extends Bloc<SavedCurrenciesEvent, SavedCurrenciesState> {
  final CurrenciesRepository currenciesRepository;
  SavedCurrenciesBloc({required this.currenciesRepository}) : super(SavedCurrenciesInitial()) {
    on<LoadSavedCurrencies>((event, emit) async {
      emit(SavedCurrencies(event.currencies));
    });

    on<SaveCurrency>((event, emit) async {
      var currentState = state;

      await currenciesRepository.saveCurrencyToDb(event.currency);

      if (currentState is SavedCurrencies) {
        var currencies = [...currentState.currencies, event.currency];
        currencies.sort((a, b) => a.name.compareTo(b.name));
        emit(SavedCurrencies(currencies));
      } else {
        emit(SavedCurrencies([event.currency]));
      }
    });

    on<DeleteSavedCurrency>((event, emit) async {
      await currenciesRepository.deleteCurrency(event.currency);

      var currentState = state;

      if (currentState is SavedCurrencies) {
        var currencies = [...currentState.currencies];
        currencies.removeWhere((element) => element.code == event.currency.code);
        emit(SavedCurrencies(currencies));
      }
    });
  }
}
