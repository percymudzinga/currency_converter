import 'package:currency_converter/app_blocs.dart';
import 'package:currency_converter/app_repositories.dart';
import 'package:currency_converter/constants/app_screens.dart';
import 'package:currency_converter/constants/hive_constants.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:currency_converter/screens/add_currency_screen.dart';
import 'package:currency_converter/screens/currency_screen.dart';
import 'package:currency_converter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CurrencyAdapter());
  await Hive.openBox<Currency>(HiveConstants.currencies);
  runApp(
    const AppRepositories(
      child: AppBlocs(
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      initialRoute: AppScreens.home,
      routes: {
        AppScreens.home: (context) => const HomeScreen(),
        AppScreens.addCurrency: (context) => const AddCurrencyScreen(),
        AppScreens.currencyScreen: (context) => const CurrencyScreen(),
      },
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0xFFff5100),
          background: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        ),
      ),
    );
  }
}
