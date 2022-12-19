import 'package:currency_converter/blocs/selected_currency_bloc/selected_currency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/currency.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late TextEditingController _baseController;
  late TextEditingController _currencyController;

  bool _isBaseTyping = false;

  @override
  void initState() {
    super.initState();
    _baseController = TextEditingController();
    _currencyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SelectedCurrencyBloc, SelectedCurrencyState>(
          builder: (context, state) {
            if (state is SelectedCurrency) {
              return Text(state.currency.name);
            }
            return const Text('Currency');
          },
        ),
      ),
      body: BlocConsumer<SelectedCurrencyBloc, SelectedCurrencyState>(
        listener: (context, state) {
          if (state is SelectedCurrency) {
            if (state.baseAmount != null && !_isBaseTyping) {
              if (state.baseAmount == 0) {
                _baseController.clear();
              } else {
                _baseController.text = state.baseAmount!.toStringAsFixed(2);
              }
            }

            if (state.currencyAmount != null && _isBaseTyping) {
              if (state.currencyAmount == 0) {
                _currencyController.clear();
              } else {
                _currencyController.text = state.currencyAmount!.toStringAsFixed(2);
              }
            }
          }
        },
        builder: (context, state) {
          if (state is! SelectedCurrency) {
            return const SizedBox();
          }
          return ListView(
            padding: const EdgeInsets.only(top: 32, right: 16, left: 16, bottom: 16),
            children: [
              _TextInput(
                currency: state.base,
                controller: _baseController,
                onChanged: (e) {
                  setState(() {
                    _isBaseTyping = true;
                  });
                  if (e.isNotEmpty) {
                    context.read<SelectedCurrencyBloc>().add(ConvertCurrency(double.parse(e), state.base));
                  } else {
                    context.read<SelectedCurrencyBloc>().add(ResetConversion());
                  }
                },
              ),
              const SizedBox(height: 32),
              _TextInput(
                currency: state.currency,
                controller: _currencyController,
                onChanged: (e) {
                  setState(() {
                    _isBaseTyping = false;
                  });
                  if (e.isNotEmpty) {
                    context.read<SelectedCurrencyBloc>().add(ConvertCurrency(double.parse(e), state.currency));
                  } else {
                    context.read<SelectedCurrencyBloc>().add(ResetConversion());
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final Currency currency;

  const _TextInput({
    this.onChanged,
    required this.currency,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(currency.code),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter amount',
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
            ),
          ),
        ],
      ),
    );
  }
}
