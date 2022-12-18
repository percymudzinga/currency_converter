part of 'saved_currencies_bloc.dart';

abstract class SavedCurrenciesEvent extends Equatable {
  const SavedCurrenciesEvent();

  @override
  List<Object> get props => [];
}

class LoadSavedCurrencies extends SavedCurrenciesEvent {
  final List<Currency> currencies;

  const LoadSavedCurrencies({required this.currencies});
}

class SaveCurrency extends SavedCurrenciesEvent {
  final Currency currency;

  const SaveCurrency(this.currency);
}

class DeleteSavedCurrency extends SavedCurrenciesEvent {
  final Currency currency;
  const DeleteSavedCurrency(this.currency);
}
