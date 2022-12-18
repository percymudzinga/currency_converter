part of 'currencies_bloc.dart';

abstract class CurrenciesEvent extends Equatable {
  const CurrenciesEvent();

  @override
  List<Object> get props => [];
}

class LoadCurrencies extends CurrenciesEvent {}
