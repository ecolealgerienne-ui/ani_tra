// lib/mock/mock_documents.dart

import '../../models/document.dart';

/// Données de test pour les documents
final List<Document> mockDocuments = [
  // === Passeports bovins ===
  Document(
    id: 'doc-001',
    farmId: 'mock-farm-001',
    animalId: 'animal-001', // Belle
    type: DocumentType.passport,
    fileName: 'Passeport_FR1234567890_Belle.pdf',
    fileUrl: '/mock/documents/passport_belle.pdf',
    fileSizeBytes: 245678,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 365)),
    expiryDate: null, // Les passeports n'expirent pas
    notes: 'Passeport bovin original',
    uploadedBy: 'Jean Dupont',
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  ),

  Document(
    id: 'doc-002',
    farmId: 'mock-farm-001',
    animalId: 'animal-002', // Marguerite
    type: DocumentType.passport,
    fileName: 'Passeport_FR1234567891_Marguerite.pdf',
    fileUrl: '/mock/documents/passport_marguerite.pdf',
    fileSizeBytes: 238950,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 320)),
    notes: 'Passeport bovin',
    uploadedBy: 'Jean Dupont',
    createdAt: DateTime.now().subtract(const Duration(days: 320)),
  ),

  // === Certificats sanitaires ===
  Document(
    id: 'doc-003',
    farmId: 'mock-farm-001',
    animalId: 'animal-001',
    type: DocumentType.certificate,
    fileName: 'Certificat_Sanitaire_Belle_2024.pdf',
    fileUrl: '/mock/documents/cert_sanitaire_belle.pdf',
    fileSizeBytes: 156789,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 90)),
    expiryDate: DateTime.now().add(const Duration(days: 275)),
    notes: 'Certificat sanitaire annuel',
    uploadedBy: 'Dr. Martin Dubois',
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  ),

  Document(
    id: 'doc-004',
    farmId: 'mock-farm-001',
    animalId: 'animal-003', // Blanchette
    type: DocumentType.certificate,
    fileName: 'Certificat_Sanitaire_Blanchette_2024.pdf',
    fileUrl: '/mock/documents/cert_sanitaire_blanchette.pdf',
    fileSizeBytes: 162345,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 60)),
    expiryDate: DateTime.now().add(const Duration(days: 305)),
    notes: 'Certificat sanitaire - Vente',
    uploadedBy: 'Dr. Martin Dubois',
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
  ),

  // === Certificat sanitaire expiré ===
  Document(
    id: 'doc-005',
    farmId: 'mock-farm-001',
    animalId: 'animal-005', // Duchesse
    type: DocumentType.certificate,
    fileName: 'Certificat_Sanitaire_Duchesse_2023.pdf',
    fileUrl: '/mock/documents/cert_sanitaire_duchesse_old.pdf',
    fileSizeBytes: 148234,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 400)),
    expiryDate: DateTime.now().subtract(const Duration(days: 35)),
    notes: '⚠️ EXPIRÉ - Renouveler',
    uploadedBy: 'Dr. Sophie Laurent',
    createdAt: DateTime.now().subtract(const Duration(days: 400)),
  ),

  // === Certificats de transport ===
  Document(
    id: 'doc-006',
    farmId: 'mock-farm-001',
    animalId: 'animal-003',
    type: DocumentType.transportCert,
    fileName: 'Certificat_Transport_Blanchette_20241015.pdf',
    fileUrl: '/mock/documents/transport_blanchette.pdf',
    fileSizeBytes: 89456,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 18)),
    expiryDate: DateTime.now().add(const Duration(days: 347)),
    notes: 'Transport vers abattoir certifié',
    uploadedBy: 'Transport Durand SA',
    createdAt: DateTime.now().subtract(const Duration(days: 18)),
  ),

  // === Rapports vétérinaires ===
  Document(
    id: 'doc-007',
    farmId: 'mock-farm-001',
    animalId: 'animal-002',
    type: DocumentType.vetReport,
    fileName: 'Rapport_Veterinaire_Marguerite_Mammite.pdf',
    fileUrl: '/mock/documents/vet_report_marguerite.pdf',
    fileSizeBytes: 234567,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 45)),
    notes: 'Traitement mammite - Suivi',
    uploadedBy: 'Dr. Martin Dubois',
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
  ),

  Document(
    id: 'doc-008',
    farmId: 'mock-farm-001',
    animalId: 'animal-001',
    type: DocumentType.vetReport,
    fileName: 'Rapport_Veterinaire_Belle_Boiterie.pdf',
    fileUrl: '/mock/documents/vet_report_belle_boiterie.pdf',
    fileSizeBytes: 198765,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 120)),
    notes: 'Traitement boiterie - Guérison complète',
    uploadedBy: 'Dr. Martin Dubois',
    createdAt: DateTime.now().subtract(const Duration(days: 120)),
  ),

  // === Certificats de saillie ===
  Document(
    id: 'doc-009',
    farmId: 'mock-farm-001',
    animalId: 'animal-002',
    type: DocumentType.breedingCert,
    fileName: 'Certificat_Saillie_Marguerite_2024.pdf',
    fileUrl: '/mock/documents/breeding_marguerite.pdf',
    fileSizeBytes: 112345,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 180)),
    notes: 'IA - Taureau Limousin #FR5678',
    uploadedBy: 'Dr. Sophie Laurent',
    createdAt: DateTime.now().subtract(const Duration(days: 180)),
  ),

  // === Factures (documents de ferme, pas d'animal) ===
  Document(
    id: 'doc-010',
    farmId: 'mock-farm-001',
    animalId: null, // Document de ferme
    type: DocumentType.invoice,
    fileName: 'Facture_Aliments_Octobre_2024.pdf',
    fileUrl: '/mock/documents/invoice_aliments_oct.pdf',
    fileSizeBytes: 67890,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 15)),
    notes: 'Achat aliments concentrés',
    uploadedBy: 'Marie Martin',
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),

  Document(
    id: 'doc-011',
    farmId: 'mock-farm-001',
    animalId: null,
    type: DocumentType.invoice,
    fileName: 'Facture_Veterinaire_Septembre_2024.pdf',
    fileUrl: '/mock/documents/invoice_vet_sept.pdf',
    fileSizeBytes: 45678,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 32)),
    notes: 'Facture vétérinaire mensuelle',
    uploadedBy: 'Jean Dupont',
    createdAt: DateTime.now().subtract(const Duration(days: 32)),
  ),

  // === Documents qui expirent bientôt ===
  Document(
    id: 'doc-012',
    farmId: 'mock-farm-001',
    animalId: 'animal-004', // Caramel
    type: DocumentType.certificate,
    fileName: 'Certificat_Sanitaire_Caramel_2024.pdf',
    fileUrl: '/mock/documents/cert_sanitaire_caramel.pdf',
    fileSizeBytes: 154321,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 340)),
    expiryDate: DateTime.now().add(const Duration(days: 25)),
    notes: '⚠️ Expire bientôt - À renouveler',
    uploadedBy: 'Dr. Martin Dubois',
    createdAt: DateTime.now().subtract(const Duration(days: 340)),
  ),

  Document(
    id: 'doc-013',
    farmId: 'mock-farm-001',
    animalId: 'animal-006', // Noisette
    type: DocumentType.certificate,
    fileName: 'Certificat_Sanitaire_Noisette_2024.pdf',
    fileUrl: '/mock/documents/cert_sanitaire_noisette.pdf',
    fileSizeBytes: 159876,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 350)),
    expiryDate: DateTime.now().add(const Duration(days: 15)),
    notes: 'Expire dans 15 jours',
    uploadedBy: 'Dr. Sophie Laurent',
    createdAt: DateTime.now().subtract(const Duration(days: 350)),
  ),

  // === Autres documents ===
  Document(
    id: 'doc-014',
    farmId: 'mock-farm-001',
    animalId: null,
    type: DocumentType.other,
    fileName: 'Plan_Batiment_Etable.pdf',
    fileUrl: '/mock/documents/plan_etable.pdf',
    fileSizeBytes: 1234567,
    mimeType: 'application/pdf',
    uploadDate: DateTime.now().subtract(const Duration(days: 730)),
    notes: 'Plan d\'architecture étable',
    uploadedBy: 'Jean Dupont',
    createdAt: DateTime.now().subtract(const Duration(days: 730)),
  ),
];

/// Statistiques des documents mock
class MockDocumentStats {
  static int get totalDocuments => mockDocuments.length;

  static int get passports =>
      mockDocuments.where((d) => d.type == DocumentType.passport).length;

  static int get certificates =>
      mockDocuments.where((d) => d.type == DocumentType.certificate).length;

  static int get vetReports =>
      mockDocuments.where((d) => d.type == DocumentType.vetReport).length;

  static int get expired => mockDocuments.where((d) => d.isExpired).length;

  static int get expiringSoon {
    return mockDocuments.where((d) {
      if (d.expiryDate == null) return false;
      final days = d.daysUntilExpiry;
      return days != null && days <= 30 && days > 0;
    }).length;
  }

  static int get totalStorageMB {
    final bytes = mockDocuments.fold<int>(
      0,
      (sum, doc) => sum + (doc.fileSizeBytes ?? 0),
    );
    return (bytes / (1024 * 1024)).round();
  }

  static int get animalDocuments =>
      mockDocuments.where((d) => d.animalId != null).length;

  static int get farmDocuments =>
      mockDocuments.where((d) => d.animalId == null).length;
}
