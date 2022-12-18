part of 'saved_currencies_bloc.dart';

abstract class SavedCurrenciesState extends Equatable {
  const SavedCurrenciesState();

  @override
  List<Object> get props => [];
}

class SavedCurrenciesInitial extends SavedCurrenciesState {}

class SavedCurrencies extends SavedCurrenciesState {
  final List<Currency> currencies;

  const SavedCurrencies(this.currencies);

  @override
  List<Object> get props => [currencies];
}
