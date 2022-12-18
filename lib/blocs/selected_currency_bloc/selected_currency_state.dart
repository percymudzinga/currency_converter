part of 'selected_currency_bloc.dart';

abstract class SelectedCurrencyState extends Equatable {
  const SelectedCurrencyState();

  @override
  List<Object?> get props => [];
}

class SelectedCurrencyInitial extends SelectedCurrencyState {}

class SelectedCurrency extends SelectedCurrencyState {
  final Currency currency;
  final Currency base;
  final double? currencyAmount;
  final double? baseAmount;

  const SelectedCurrency({
    required this.currency,
    required this.base,
    this.currencyAmount,
    this.baseAmount,
  });

  SelectedCurrency copyWith({
    Currency? currency,
    Currency? base,
    double? currencyAmount,
    double? baseAmount,
  }) {
    return SelectedCurrency(
      currency: currency ?? this.currency,
      base: base ?? this.base,
      currencyAmount: currencyAmount ?? this.currencyAmount,
      baseAmount: baseAmount ?? this.baseAmount,
    );
  }

  @override
  List<Object?> get props => [currency, base, currencyAmount, baseAmount];
}
