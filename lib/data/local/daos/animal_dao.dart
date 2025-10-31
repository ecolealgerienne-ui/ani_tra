// lib/data/local/daos/animal_dao.dart
import 'package:drift/drift.dart';

import '../db.dart';
import '../tables/animals.dart';

part 'animal_dao.g.dart';

/// DAO = accès bas niveau à la table `animals`
/// Utilise les types Drift générés:
///   - Data class: `Animal` (singulier)
///   - Companion: `AnimalsCompanion`
@DriftAccessor(tables: [Animals])
class AnimalDao extends DatabaseAccessor<AppDatabase> with _$AnimalDaoMixin {
  AnimalDao(AppDatabase db) : super(db);

  // ------- READ -------

  /// Liste des animaux non supprimés (ordonnée par `eid` asc)
  Future<List<Animal>> getAll() {
    return (select(animals)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.eid, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère un animal par id (même s’il est supprimé logiquement)
  Future<Animal?> getById(String id) {
    return (select(animals)..where((t) => t.id.equals(id))).getSingleOrNull();
    // Si tu veux exclure les supprimés logiquement :
    // return (select(animals)
    //       ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
    //     .getSingleOrNull();
  }

  /// Compte des animaux non supprimés
  Future<int> countActive() async {
    final exp = animals.id.count();
    final q = selectOnly(animals)
      ..where(animals.isDeleted.equals(false))
      ..addColumns([exp]);
    final row = await q.getSingle();
    return row.read(exp) ?? 0;
  }

  // ------- WRITE / UPSERT -------

  /// Insert ou update (OnConflict: UPDATE sur clé primaire `id`)
  Future<void> upsert(AnimalsCompanion companion) async {
    await into(animals).insertOnConflictUpdate(companion);
  }

  /// Batch d’upserts
  Future<void> upsertMany(List<AnimalsCompanion> companions) async {
    if (companions.isEmpty) return;
    await batch((b) {
      b.insertAllOnConflictUpdate(animals, companions);
    });
  }

  // ------- DELETE -------

  /// Soft delete: marque `isDeleted=true` et met à jour `updatedAt`
  Future<void> softDelete(String id) async {
    await (update(animals)..where((t) => t.id.equals(id))).write(
      AnimalsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now().toUtc().toIso8601String()),
      ),
    );
  }

  /// (Optionnel) Suppression physique — à éviter en production
  Future<int> deleteHard(String id) {
    return (delete(animals)..where((t) => t.id.equals(id))).go();
  }

  // ------- WATCH (optionnel) -------

  /// Stream des animaux non supprimés
  Stream<List<Animal>> watchAll() {
    return (select(animals)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.eid, mode: OrderingMode.asc),
          ]))
        .watch();
  }
}
