import 'package:currency_converter/blocs/currencies_bloc/currencies_bloc.dart';
import 'package:currency_converter/blocs/saved_currencies_bloc/saved_currencies_bloc.dart';
import 'package:currency_converter/blocs/selected_currency_bloc/selected_currency_bloc.dart';
import 'package:currency_converter/repositories/currencies_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocs extends StatelessWidget {
  final Widget child;
  const AppBlocs({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SavedCurrenciesBloc(
            currenciesRepository: RepositoryProvider.of<CurrenciesRepository>(context),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => CurrenciesBloc(
            currenciesRepository: RepositoryProvider.of<CurrenciesRepository>(context),
            savedCurrenciesBloc: BlocProvider.of<SavedCurrenciesBloc>(context),
          )..add(LoadCurrencies()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SelectedCurrencyBloc(
            currenciesBloc: BlocProvider.of<CurrenciesBloc>(context),
          ),
        ),
      ],
      child: child,
    );
  }
}
