// lib/models/farm.dart

/// Ferme (exploitation agricole)
class Farm {
  final String id;
  final String name;
  final String location;
  
  // Propriétaire
  final String ownerId;
  
  // Numéro de cheptel
  final String? cheptelNumber;
  
  // Groupe (optionnel)
  final String? groupId;
  final String? groupName;
  
  // Métadonnées
  final DateTime createdAt;
  final DateTime updatedAt;

  const Farm({
    required this.id,
    required this.name,
    required this.location,
    required this.ownerId,
    this.cheptelNumber,
    this.groupId,
    this.groupName,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Farm copyWith({
    String? name,
    String? location,
    String? cheptelNumber,
    String? groupId,
    String? groupName,
    DateTime? updatedAt,
  }) {
    return Farm(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      ownerId: ownerId,
      cheptelNumber: cheptelNumber ?? this.cheptelNumber,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'ownerId': ownerId,
      'cheptelNumber': cheptelNumber,
      'groupId': groupId,
      'groupName': groupName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      ownerId: json['ownerId'] as String,
      cheptelNumber: json['cheptelNumber'] as String?,
      groupId: json['groupId'] as String?,
      groupName: json['groupName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
