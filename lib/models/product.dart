class Product {
  final String id;
  final String name;
  final String activeSubstance;
  final int withdrawalDaysMeat;
  final int? withdrawalDaysMilk;
  final double dosagePerKg;

  Product({
    required this.id,
    required this.name,
    required this.activeSubstance,
    required this.withdrawalDaysMeat,
    this.withdrawalDaysMilk,
    required this.dosagePerKg,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'active_substance': activeSubstance,
      'withdrawal_days_meat': withdrawalDaysMeat,
      'withdrawal_days_milk': withdrawalDaysMilk,
      'dosage_per_kg': dosagePerKg,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      activeSubstance: json['active_substance'],
      withdrawalDaysMeat: json['withdrawal_days_meat'],
      withdrawalDaysMilk: json['withdrawal_days_milk'],
      dosagePerKg: json['dosage_per_kg'].toDouble(),
    );
  }
}
