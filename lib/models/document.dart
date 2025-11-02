// lib/models/document.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Type de document
enum DocumentType {
  passport, // Passeport bovin
  certificate, // Certificat sanitaire
  invoice, // Facture
  transportCert, // Certificat de transport
  breedingCert, // Certificat de saillie
  vetReport, // Rapport vétérinaire
  other, // Autre
}

/// Document lié à un animal ou à la ferme
class Document implements SyncableEntity {
  @override
  final String id;
  @override
  final String farmId;

  /// ID de l'animal (optionnel si doc de ferme)
  final String? animalId;

  /// Type de document
  final DocumentType type;

  /// Nom du fichier
  final String fileName;

  /// URL locale ou distante du fichier
  final String fileUrl;

  /// Taille du fichier (bytes)
  final int? fileSizeBytes;

  /// Type MIME
  final String? mimeType;

  /// Date d'upload
  final DateTime uploadDate;

  /// Date d'expiration (optionnelle)
  final DateTime? expiryDate;

  /// Notes additionnelles
  final String? notes;

  /// Uploadé par (user ID)
  final String? uploadedBy;

  // === Synchronisation ===
  @override
  final bool synced;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  final String? serverVersion;

  Document({
    String? id,
    required this.farmId,
    this.animalId,
    required this.type,
    required this.fileName,
    required this.fileUrl,
    this.fileSizeBytes,
    this.mimeType,
    required this.uploadDate,
    this.expiryDate,
    this.notes,
    this.uploadedBy,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Document expiré ?
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Jours avant expiration
  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  /// Extension du fichier
  String get fileExtension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// Taille formatée (KB, MB)
  String get formattedFileSize {
    if (fileSizeBytes == null) return 'N/A';
    if (fileSizeBytes! < 1024) return '${fileSizeBytes}B';
    if (fileSizeBytes! < 1024 * 1024) {
      return '${(fileSizeBytes! / 1024).toStringAsFixed(1)}KB';
    }
    return '${(fileSizeBytes! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  Document copyWith({
    String? animalId,
    DocumentType? type,
    String? fileName,
    String? fileUrl,
    int? fileSizeBytes,
    String? mimeType,
    DateTime? uploadDate,
    DateTime? expiryDate,
    String? notes,
    String? uploadedBy,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Document(
      id: id,
      farmId: farmId,
      animalId: animalId ?? this.animalId,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      mimeType: mimeType ?? this.mimeType,
      uploadDate: uploadDate ?? this.uploadDate,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  /// Méthodes de sync
  Document markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  Document markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'animalId': animalId,
      'type': type.name,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSizeBytes': fileSizeBytes,
      'mimeType': mimeType,
      'uploadDate': uploadDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'notes': notes,
      'uploadedBy': uploadedBy,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      animalId: json['animalId'] as String?,
      type: DocumentType.values.byName(json['type'] as String),
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileSizeBytes: json['fileSizeBytes'] as int?,
      mimeType: json['mimeType'] as String?,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      notes: json['notes'] as String?,
      uploadedBy: json['uploadedBy'] as String?,
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      serverVersion: json['serverVersion'] as String?,
    );
  }
}
