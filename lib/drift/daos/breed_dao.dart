// lib/drift/daos/breed_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/breeds_table.dart';

part 'breed_dao.g.dart';

@DriftAccessor(tables: [BreedsTable])
class BreedDao extends DatabaseAccessor<AppDatabase> with _$BreedDaoMixin {
  BreedDao(super.db);

  // 1. Get all breeds (ordered by display_order)
  Future<List<BreedsTableData>> findAll() {
    return (select(breedsTable)
      ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
      .get();
  }

  // 2. Get all active breeds (ordered by display_order)
  Future<List<BreedsTableData>> findAllActive() {
    return (select(breedsTable)
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
      .get();
  }

  // 3. Get breed by ID
  Future<BreedsTableData?> findById(String id) {
    return (select(breedsTable)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
  }

  // 4. Get breeds by species ID
  Future<List<BreedsTableData>> findBySpeciesId(String speciesId) {
    return (select(breedsTable)
      ..where((t) => t.speciesId.equals(speciesId))
      ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
      .get();
  }

  // 5. Get active breeds by species ID
  Future<List<BreedsTableData>> findActiveBySpeciesId(String speciesId) {
    return (select(breedsTable)
      ..where((t) => t.speciesId.equals(speciesId))
      ..where((t) => t.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
      .get();
  }

  // 6. Insert breed
  Future<int> insertBreed(BreedsTableCompanion breed) {
    return into(breedsTable).insert(breed);
  }

  // 7. Update breed
  Future<bool> updateBreed(BreedsTableCompanion breed) {
    return update(breedsTable).replace(breed);
  }

  // 8. Delete breed (hard delete - referential table)
  Future<int> deleteBreed(String id) {
    return (delete(breedsTable)
      ..where((t) => t.id.equals(id)))
      .go();
  }

  // 9. Count breeds
  Future<int> countBreeds() {
    final query = selectOnly(breedsTable)
      ..addColumns([breedsTable.id.count()]);
    
    return query.map((row) => row.read(breedsTable.id.count())!).getSingle();
  }

  // 10. Count breeds by species
  Future<int> countBySpeciesId(String speciesId) {
    final query = selectOnly(breedsTable)
      ..addColumns([breedsTable.id.count()])
      ..where(breedsTable.speciesId.equals(speciesId));
    
    return query.map((row) => row.read(breedsTable.id.count())!).getSingle();
  }

  // 11. Search breeds by name (any language)
  Future<List<BreedsTableData>> searchByName(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(breedsTable)
      ..where((t) => 
        t.nameFr.lower().like(lowerQuery) |
        t.nameEn.lower().like(lowerQuery) |
        t.nameAr.like('%$query%')
      )
      ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
      .get();
  }

  // 12. Check if breed exists
  Future<bool> exists(String id) async {
    final result = await (select(breedsTable)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
    return result != null;
  }

  // 13. Toggle active status
  Future<int> toggleActive(String id) async {
    final breed = await findById(id);
    if (breed == null) return 0;
    
    return (update(breedsTable)
      ..where((t) => t.id.equals(id)))
      .write(BreedsTableCompanion(
        isActive: Value(!breed.isActive),
      ));
  }
}
