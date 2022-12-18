part of 'selected_currency_bloc.dart';

abstract class SelectedCurrencyEvent extends Equatable {
  const SelectedCurrencyEvent();

  @override
  List<Object> get props => [];
}

class SelectCurrency extends SelectedCurrencyEvent {
  final Currency currency;

  const SelectCurrency({required this.currency});
}

class ConvertCurrency extends SelectedCurrencyEvent {
  final Currency currency;
  final double amount;

  const ConvertCurrency(this.amount, this.currency);
}

class ResetConversion extends SelectedCurrencyEvent {}
