import 'package:bloc/bloc.dart';
import 'package:currency_converter/blocs/currencies_bloc/currencies_bloc.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:equatable/equatable.dart';

part 'selected_currency_event.dart';
part 'selected_currency_state.dart';

class SelectedCurrencyBloc extends Bloc<SelectedCurrencyEvent, SelectedCurrencyState> {
  final CurrenciesBloc currenciesBloc;
  SelectedCurrencyBloc({
    required this.currenciesBloc,
  }) : super(SelectedCurrencyInitial()) {
    on<SelectCurrency>((event, emit) {
      var currenciesState = currenciesBloc.state;
      if (currenciesState is! CurrenciesLoaded) return;

      emit(
        SelectedCurrency(
          currency: event.currency,
          base: currenciesState.currencies.firstWhere((e) => e.isBase),
        ),
      );
    });

    on<ConvertCurrency>((event, emit) {
      var currentState = state;

      if (currentState is! SelectedCurrency) return;

      if (event.currency == currentState.base) {
        var convertedAmount = event.amount * currentState.currency.rate;
        convertedAmount = convertedAmount + (0.07 * convertedAmount);

        emit(currentState.copyWith(currencyAmount: convertedAmount, baseAmount: event.amount));
      } else {
        var convertedAmount = event.amount / currentState.currency.rate;

        convertedAmount = convertedAmount + (0.07 * convertedAmount);

        emit(currentState.copyWith(currencyAmount: event.amount, baseAmount: convertedAmount));
      }
    });

    on<ResetConversion>((event, emit) {
      var currentState = state;
      if (currentState is! SelectedCurrency) return;
      emit(currentState.copyWith(baseAmount: 0, currencyAmount: 0));
    });
  }
}
