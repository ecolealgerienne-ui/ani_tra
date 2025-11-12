// lib/drift/tables/documents_table.dart
import 'package:drift/drift.dart';

class DocumentsTable extends Table {
  @override
  String get tableName => 'documents';

  // Primary key
  TextColumn get id => text()();

  // Multi-tenancy
  TextColumn get farmId => text().named('farm_id')();

  // Animal reference (optional - can be farm-level document)
  TextColumn get animalId => text().nullable().named('animal_id')();

  // Document metadata
  TextColumn get type => text()(); // 'passport', 'certificate', 'invoice', etc.
  TextColumn get fileName => text().named('file_name')();
  TextColumn get fileUrl => text().named('file_url')();
  IntColumn get fileSizeBytes =>
      integer().nullable().named('file_size_bytes')();
  TextColumn get mimeType => text().nullable().named('mime_type')();

  // Dates
  DateTimeColumn get uploadDate => dateTime().named('upload_date')();
  DateTimeColumn get expiryDate => dateTime().nullable().named('expiry_date')();

  // Additional info
  TextColumn get notes => text().nullable()();
  TextColumn get uploadedBy => text().nullable().named('uploaded_by')();

  // Sync fields (Phase 2 ready)
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  // Soft-delete (audit trail)
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',
        'FOREIGN KEY (animal_id) REFERENCES animals(id)',
        'CREATE INDEX IF NOT EXISTS idx_documents_farm_id ON documents(farm_id)',
        'CREATE INDEX IF NOT EXISTS idx_documents_farm_created ON documents(farm_id, created_at DESC)',
        'CREATE INDEX IF NOT EXISTS idx_documents_deleted_at ON documents(deleted_at)',
      ];
}
