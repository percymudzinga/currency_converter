import 'package:currency_converter/blocs/currencies_bloc/currencies_bloc.dart';
import 'package:currency_converter/blocs/saved_currencies_bloc/saved_currencies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/currency.dart';

class AddCurrencyScreen extends StatelessWidget {
  const AddCurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Currency'),
      ),
      body: BlocBuilder<CurrenciesBloc, CurrenciesState>(builder: (context, state) {
        if (state is CurrenciesLoaded) {
          return _buildCurrenciesList(state.currencies);
        }
        return _buildLoading();
      }),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCurrenciesList(List<Currency> currencies) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var currency = currencies[index];
        return ListTile(
          title: Text(currency.name),
          subtitle: Text(currency.rate.toStringAsFixed(2)),
          onTap: () => _saveCurrency(context, currency),
        );
      },
      itemCount: currencies.length,
    );
  }

  _saveCurrency(BuildContext context, Currency currency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Monitor Currency?'),
        content: Text("Please confirm that you want to monitor ${currency.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<SavedCurrenciesBloc>(context).add(SaveCurrency(currency));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
