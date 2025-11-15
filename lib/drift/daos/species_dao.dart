// lib/drift/daos/species_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/species_table.dart';

part 'species_dao.g.dart';

@DriftAccessor(tables: [SpeciesTable])
class SpeciesDao extends DatabaseAccessor<AppDatabase> with _$SpeciesDaoMixin {
  SpeciesDao(super.db);

  // 1. Get all species (ordered by display_order)
  Future<List<SpeciesTableData>> findAll() {
    return (select(speciesTable)
          ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .get();
  }

  // 2. Get species by ID
  Future<SpeciesTableData?> findById(String id) {
    return (select(speciesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 3. Insert species
  Future<int> insertSpecies(SpeciesTableCompanion species) {
    return into(speciesTable).insert(species);
  }

  // 4. Update species
  Future<bool> updateSpecies(SpeciesTableCompanion species) {
    return update(speciesTable).replace(species);
  }

  // 5. Delete species (hard delete - referential table)
  Future<int> deleteSpecies(String id) {
    return (delete(speciesTable)..where((t) => t.id.equals(id))).go();
  }

  // 6. Count species
  Future<int> countSpecies() {
    final query = selectOnly(speciesTable)
      ..addColumns([speciesTable.id.count()]);

    return query.map((row) => row.read(speciesTable.id.count())!).getSingle();
  }

  // 7. Search species by name (any language)
  Future<List<SpeciesTableData>> searchByName(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(speciesTable)
          ..where((t) =>
              t.nameFr.lower().like(lowerQuery) |
              t.nameEn.lower().like(lowerQuery) |
              t.nameAr.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .get();
  }

  // 8. Check if species exists
  Future<bool> exists(String id) async {
    final result = await (select(speciesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return result != null;
  }
}
