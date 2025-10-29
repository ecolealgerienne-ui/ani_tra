// lib/models/product.dart

class Product {
  final String id;
  final String name;
  final String activeSubstance;
  final int withdrawalDaysMeat;
  final int? withdrawalDaysMilk;
  final double dosagePerKg;

  const Product({
    required this.id,
    required this.name,
    required this.activeSubstance,
    required this.withdrawalDaysMeat,
    this.withdrawalDaysMilk,
    required this.dosagePerKg,
  });

  Product copyWith({
    String? id,
    String? name,
    String? activeSubstance,
    int? withdrawalDaysMeat,
    int? withdrawalDaysMilk,
    double? dosagePerKg,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      activeSubstance: activeSubstance ?? this.activeSubstance,
      withdrawalDaysMeat: withdrawalDaysMeat ?? this.withdrawalDaysMeat,
      withdrawalDaysMilk: withdrawalDaysMilk ?? this.withdrawalDaysMilk,
      dosagePerKg: dosagePerKg ?? this.dosagePerKg,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'active_substance': activeSubstance,
        'withdrawal_days_meat': withdrawalDaysMeat,
        'withdrawal_days_milk': withdrawalDaysMilk,
        'dosage_per_kg': dosagePerKg,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      activeSubstance: json['active_substance'] as String,
      withdrawalDaysMeat: json['withdrawal_days_meat'] as int,
      withdrawalDaysMilk: json['withdrawal_days_milk'] as int?,
      dosagePerKg: (json['dosage_per_kg'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'Product(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.activeSubstance == activeSubstance &&
        other.withdrawalDaysMeat == withdrawalDaysMeat &&
        other.withdrawalDaysMilk == withdrawalDaysMilk &&
        other.dosagePerKg == dosagePerKg;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        activeSubstance,
        withdrawalDaysMeat,
        withdrawalDaysMilk,
        dosagePerKg,
      );
}
