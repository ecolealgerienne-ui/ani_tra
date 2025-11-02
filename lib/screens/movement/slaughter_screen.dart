import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import '../../models/animal.dart';
import '../../models/batch.dart';
import '../../models/slaughter.dart';
import '../../models/treatment.dart';
import '../../providers/animal_provider.dart';
import '../../providers/batch_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/qr_provider.dart';

/// Écran d'enregistrement d'abattage avec vérification de rémanence
///
/// Fonctionnalités :
/// - Support lot pré-chargé ou sélection manuelle
/// - Vérification automatique des périodes de rémanence
/// - Blocage si animal non abattable
/// - Scan QR Code abattoir (validation offline)
/// - Mise à jour statuts animaux
class SlaughterScreen extends StatefulWidget {
  final Batch? preloadedBatch;

  const SlaughterScreen({
    Key? key,
    this.preloadedBatch,
  }) : super(key: key);

  @override
  State<SlaughterScreen> createState() => _SlaughterScreenState();
}

class _SlaughterScreenState extends State<SlaughterScreen> {
  final _uuid = const Uuid();
  final _notesController = TextEditingController();
  final _random = Random();

  List<String> _selectedAnimalIds = [];
  List<Animal> _blockedAnimals = [];
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic>? _slaughterhouse;

  @override
  void initState() {
    super.initState();

    // Si lot pré-chargé, charger les animaux
    if (widget.preloadedBatch != null) {
      _selectedAnimalIds = List.from(widget.preloadedBatch!.animalIds);

      // Vérifier immédiatement les rémanences
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkWithdrawal();
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Helper: Formater l'âge d'un animal
  String _getAgeFormatted(Animal animal) {
    final ageMonths = animal.ageInMonths;
    if (ageMonths < 12) {
      return '$ageMonths mois';
    }
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    return months > 0 ? '$years ans $months mois' : '$years ans';
  }

  /// Vérifie les périodes de rémanence pour tous les animaux sélectionnés
  void _checkWithdrawal() {
    final animalProvider = context.read<AnimalProvider>();
    final blocked = <Animal>[];

    for (final animalId in _selectedAnimalIds) {
      final animal = animalProvider.getAnimalById(animalId);
      if (animal == null) continue;

      // Récupérer tous les traitements de l'animal
      final treatments = animalProvider.getAnimalTreatments(animalId);

      // Vérifier si au moins un traitement a une rémanence active
      bool hasActiveWithdrawal = false;
      for (final treatment in treatments) {
        if (treatment.isWithdrawalActive) {
          hasActiveWithdrawal = true;
          break;
        }
      }

      if (hasActiveWithdrawal) {
        blocked.add(animal);
      }
    }

    setState(() {
      _blockedAnimals = blocked;
    });
  }

  /// Retire les animaux bloqués de la sélection
  void _removeBlockedAnimals() {
    setState(() {
      for (final animal in _blockedAnimals) {
        _selectedAnimalIds.remove(animal.id);
      }
      _blockedAnimals.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Animaux non abattables retirés'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Recherche un abattoir (TODO: à implémenter avec vraie DB)
  void _searchSlaughterhouse() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recherche abattoir - À venir'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Scan QR Code abattoir avec validation offline
  Future<void> _scanSlaughterhouseQR() async {
    final qrProvider = context.read<QRProvider>();

    // Simulation : générer un QR mock pour abattoir
    final mockQR = qrProvider.generateDummyQR('OTHER'); // Simule abattoir

    // Simuler les données d'un abattoir
    final mockSlaughterhouse = {
      'id': 'ABT_${_random.nextInt(9999)}',
      'name': 'Abattoir Municipal ${_random.nextInt(100)}',
      'type': 'SLAUGHTERHOUSE',
    };

    setState(() {
      _slaughterhouse = mockSlaughterhouse;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${mockSlaughterhouse['name']} validé',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Récupère la date de fin de rémanence la plus proche pour un animal
  String _getEarliestWithdrawalEnd(String animalId) {
    final animalProvider = context.read<AnimalProvider>();
    final treatments = animalProvider.getAnimalTreatments(animalId);

    DateTime? earliest;
    for (final treatment in treatments) {
      if (treatment.isWithdrawalActive) {
        if (earliest == null ||
            treatment.withdrawalEndDate.isBefore(earliest)) {
          earliest = treatment.withdrawalEndDate;
        }
      }
    }

    if (earliest == null) return 'N/A';

    return '${earliest.day.toString().padLeft(2, '0')}/'
        '${earliest.month.toString().padLeft(2, '0')}/'
        '${earliest.year}';
  }

  /// Confirme l'abattage et enregistre les données
  void _confirmSlaughter() async {
    // Vérification finale des rémanences
    _checkWithdrawal();

    if (_blockedAnimals.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ Animaux non abattables'),
          content: Text(
            '${_blockedAnimals.length} animal(aux) en période de rémanence active. '
            'Veuillez les retirer avant de continuer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_selectedAnimalIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun animal sélectionné'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Créer l'enregistrement d'abattage
    final slaughter = Slaughter(
      id: _uuid.v4(),
      animalIds: _selectedAnimalIds,
      batchId: widget.preloadedBatch?.id,
      slaughterhouseId: _slaughterhouse?['id'],
      slaughterhouseName: _slaughterhouse?['name'],
      slaughterDate: _selectedDate,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      synced: false,
      createdAt: DateTime.now(),
    );

    // TODO: Ajouter SlaughterProvider pour sauvegarder
    // slaughterProvider.addSlaughter(slaughter);

    // Mettre à jour les statuts des animaux
    final animalProvider = context.read<AnimalProvider>();
    for (final animalId in _selectedAnimalIds) {
      animalProvider.updateAnimalStatus(animalId, AnimalStatus.slaughtered);
    }

    // Marquer le lot comme utilisé si fourni
    if (widget.preloadedBatch != null) {
      final batchProvider = context.read<BatchProvider>();
      batchProvider.completeBatch(widget.preloadedBatch!.id);
    }

    // Incrémenter les données en attente de sync
    context.read<SyncProvider>().incrementPendingData();

    // Navigation retour avec feedback
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_selectedAnimalIds.length} animaux enregistrés pour abattage',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.preloadedBatch != null
            ? Text('Abattage - Lot ${widget.preloadedBatch!.name}')
            : const Text('Enregistrer Abattage'),
        actions: [
          if (_blockedAnimals.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Retirer animaux non abattables',
              onPressed: _removeBlockedAnimals,
            ),
        ],
      ),
      body: Column(
        children: [
          // Bannière d'avertissement si animaux bloqués
          if (_blockedAnimals.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red[100],
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '⚠️ ${_blockedAnimals.length} animaux en rémanence active',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _removeBlockedAnimals,
                    child: const Text('RETIRER'),
                  ),
                ],
              ),
            ),

          // Corps principal
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Étape 1: Sélection Animaux
                _buildSectionTitle('Animaux sélectionnés'),
                _buildAnimalsList(),
                const SizedBox(height: 24),

                // Étape 2: Informations abattage
                _buildSectionTitle('Informations abattage'),
                _buildSlaughterInfo(),
                const SizedBox(height: 24),

                // Étape 3: Notes
                _buildSectionTitle('Notes (optionnel)'),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Informations complémentaires...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Bouton de confirmation
                ElevatedButton(
                  onPressed:
                      _selectedAnimalIds.isEmpty || _blockedAnimals.isNotEmpty
                          ? null
                          : _confirmSlaughter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Confirmer abattage (${_selectedAnimalIds.length} animaux)',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnimalsList() {
    if (_selectedAnimalIds.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.pets, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Aucun animal sélectionné',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final animalProvider = context.watch<AnimalProvider>();

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _selectedAnimalIds.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final animalId = _selectedAnimalIds[index];
          final animal = animalProvider.getAnimalById(animalId);

          if (animal == null) {
            return const ListTile(
              title: Text('Animal introuvable'),
            );
          }

          final treatments = animalProvider.getAnimalTreatments(animalId);
          final hasActiveWithdrawal =
              treatments.any((t) => t.isWithdrawalActive);
          final isBlocked = _blockedAnimals.any((a) => a.id == animalId);

          return ListTile(
            leading: Icon(
              animal.sex == AnimalSex.male ? Icons.male : Icons.female,
              color: isBlocked
                  ? Colors.red
                  : (animal.sex == AnimalSex.male ? Colors.blue : Colors.pink),
            ),
            title: Text(
              animal.officialNumber ?? animal.eid,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: isBlocked ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              '${animal.sex == AnimalSex.male ? '♂️ Mâle' : '♀️ Femelle'} · '
              '${_getAgeFormatted(animal)}'
              '${hasActiveWithdrawal ? ' · ⚠️ Rémanence active' : ''}',
              style: TextStyle(
                color: hasActiveWithdrawal ? Colors.red : Colors.grey[600],
              ),
            ),
            trailing: isBlocked
                ? Text(
                    'Fin: ${_getEarliestWithdrawalEnd(animalId)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildSlaughterInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date d'abattage
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date d\'abattage'),
              subtitle: Text(
                '${_selectedDate.day.toString().padLeft(2, '0')}/'
                '${_selectedDate.month.toString().padLeft(2, '0')}/'
                '${_selectedDate.year}',
              ),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 7)),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
            const Divider(),

            // Abattoir
            if (_slaughterhouse == null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _searchSlaughterhouse,
                      icon: const Icon(Icons.search),
                      label: const Text('Rechercher'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _scanSlaughterhouseQR,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scanner QR'),
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Abattoir validé',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _slaughterhouse!['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() => _slaughterhouse = null);
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
