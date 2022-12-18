import 'package:hive/hive.dart';
part 'currency.g.dart';

@HiveType(typeId: 1)
class Currency {
  @HiveField(0)
  final String code;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double rate;
  @HiveField(3)
  final bool isBase;
  @HiveField(4)
  final bool isMonitored;

  Currency({
    required this.code,
    required this.name,
    required this.rate,
    required this.isBase,
    required this.isMonitored,
  });

  Currency copyWith({
    String? code,
    String? name,
    double? rate,
    bool? isBase,
    bool? isMonitored,
  }) {
    return Currency(
      code: code ?? this.code,
      name: name ?? this.name,
      rate: rate ?? this.rate,
      isBase: isBase ?? this.isBase,
      isMonitored: isMonitored ?? this.isMonitored,
    );
  }
}
