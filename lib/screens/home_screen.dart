import 'package:currency_converter/blocs/saved_currencies_bloc/saved_currencies_bloc.dart';
import 'package:currency_converter/blocs/selected_currency_bloc/selected_currency_bloc.dart';
import 'package:currency_converter/constants/app_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/currency.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Rate Monitor.'),
      ),
      body: BlocBuilder<SavedCurrenciesBloc, SavedCurrenciesState>(
        builder: (context, state) {
          if (state is SavedCurrencies) {
            if (state.currencies.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "Please click + to add currencies to monitor.",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                var currency = state.currencies[index];
                return ListTile(
                  title: Text(currency.name),
                  subtitle: Text(currency.rate.toStringAsFixed(2)),
                  onTap: () {
                    context.read<SelectedCurrencyBloc>().add(SelectCurrency(currency: currency));
                    Navigator.of(context).pushNamed(AppScreens.currencyScreen);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteCurrency(context, currency),
                  ),
                );
              },
              itemCount: state.currencies.length,
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppScreens.addCurrency);
        },
      ),
    );
  }

  _deleteCurrency(BuildContext context, Currency currency) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Currency?'),
          content: Text('Are you sure you want to stop monitoring ${currency.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<SavedCurrenciesBloc>().add(DeleteSavedCurrency(currency));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
