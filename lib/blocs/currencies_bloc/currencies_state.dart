part of 'currencies_bloc.dart';

abstract class CurrenciesState extends Equatable {
  const CurrenciesState();

  @override
  List<Object> get props => [];
}

class CurrenciesInitial extends CurrenciesState {}

class CurrenciesLoading extends CurrenciesState {}

class CurrenciesLoaded extends CurrenciesState {
  final List<Currency> currencies;

  const CurrenciesLoaded({required this.currencies});

  @override
  List<Object> get props => [currencies];
}
