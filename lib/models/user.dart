// lib/models/user.dart

/// Utilisateur (fermier)
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;

  // Multi-ferme
  final List<String> farmIds;
  final String currentFarmId;

  // Groupe (optionnel)
  final String? groupId;

  // Métadonnées
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.farmIds,
    required this.currentFarmId,
    this.groupId,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? email,
    String? name,
    String? phone,
    List<String>? farmIds,
    String? currentFarmId,
    String? groupId,
    DateTime? updatedAt,
  }) {
    return User(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      farmIds: farmIds ?? this.farmIds,
      currentFarmId: currentFarmId ?? this.currentFarmId,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'farmIds': farmIds,
      'currentFarmId': currentFarmId,
      'groupId': groupId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      farmIds:
          (json['farmIds'] as List<dynamic>).map((e) => e as String).toList(),
      currentFarmId: json['currentFarmId'] as String,
      groupId: json['groupId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
