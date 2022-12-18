import 'package:json_annotation/json_annotation.dart';
part 'currency_rates_response.g.dart';

@JsonSerializable()
class CurrencyRatesResponse {
  final String base;
  final Map<String, double> rates;

  CurrencyRatesResponse({
    required this.base,
    required this.rates,
  });

  factory CurrencyRatesResponse.fromJson(Map<String, dynamic> json) => _$CurrencyRatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyRatesResponseToJson(this);
}
