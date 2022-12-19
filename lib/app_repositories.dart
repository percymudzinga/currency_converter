import 'package:currency_converter/repositories/currencies_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class AppRepositories extends StatelessWidget {
  final Widget child;
  const AppRepositories({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CurrenciesRepository(hive: Hive),
        ),
      ],
      child: child,
    );
  }
}
