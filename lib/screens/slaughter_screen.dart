import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/animal.dart';
import '../models/batch.dart';
import '../models/slaughter.dart';
import '../models/treatment.dart';
import '../providers/animal_provider.dart';
import '../providers/batch_provider.dart';
import '../providers/sync_provider.dart';
import '../providers/qr_provider.dart';

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
    final mockQR = qrProvider.generateMockQR('slaughterhouse');

    // Valider le QR Code
    await qrProvider.scanQRCode(mockQR);

    if (qrProvider.validatedUser != null) {
      setState(() {
        _slaughterhouse = qrProvider.validatedUser;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ ${qrProvider.validatedUser!['name']} validé',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
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
    final animalProvider = context.watch<AnimalProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Abattage'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section animaux sélectionnés
            _buildAnimalsList(animalProvider),

            const SizedBox(height: 24),

            // Alerte si animaux bloqués
            if (_blockedAnimals.isNotEmpty) ...[
              _buildBlockedAlert(),
              const SizedBox(height: 24),
            ],

            // Informations abattage
            _buildSlaughterInfo(),

            const SizedBox(height: 32),

            // Boutons d'action
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Construit la liste des animaux sélectionnés
  Widget _buildAnimalsList(AnimalProvider animalProvider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pets, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Animaux sélectionnés (${_selectedAnimalIds.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_selectedAnimalIds.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Aucun animal sélectionné',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ...(_selectedAnimalIds.map((animalId) {
                final animal = animalProvider.getAnimalById(animalId);
                if (animal == null) return const SizedBox.shrink();

                final isBlocked = _blockedAnimals.any((a) => a.id == animalId);
                final treatments = animalProvider.getAnimalTreatments(animalId);

                bool hasActiveWithdrawal = false;
                for (final treatment in treatments) {
                  if (treatment.isWithdrawalActive) {
                    hasActiveWithdrawal = true;
                    break;
                  }
                }

                return ListTile(
                  leading: Icon(
                    isBlocked ? Icons.warning : Icons.check_circle,
                    color: isBlocked ? Colors.red : Colors.green,
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
                    '${animal.ageFormatted}'
                    '${hasActiveWithdrawal ? ' · ⚠️ Rémanence active' : ''}',
                    style: TextStyle(
                      color:
                          hasActiveWithdrawal ? Colors.red : Colors.grey[600],
                    ),
                  ),
                  trailing: isBlocked
                      ? Text(
                          'Fin: ${_getEarliestWithdrawalEnd(animalId)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      : null,
                );
              })),
          ],
        ),
      ),
    );
  }

  /// Construit l'alerte pour les animaux bloqués
  Widget _buildBlockedAlert() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'ATTENTION : ${_blockedAnimals.length} animal(aux) non abattable(s)',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Les animaux suivants sont en période de rémanence active :',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          ..._blockedAnimals.map((animal) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${animal.officialNumber ?? animal.eid} - '
                        'Fin rémanence: ${_getEarliestWithdrawalEnd(animal.id)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _removeBlockedAnimals,
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text('Retirer ces animaux'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler l\'abattage'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit la section informations d'abattage
  Widget _buildSlaughterInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations Abattage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),

            // Section abattoir
            const Text(
              'Abattoir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
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
            ),

            if (_slaughterhouse != null) ...[
              const SizedBox(height: 12),
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
                          Text(
                            _slaughterhouse!['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (_slaughterhouse!['org'] != null)
                            Text(
                              _slaughterhouse!['org'],
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          const Text(
                            '(Scan QR validé)',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _slaughterhouse = null),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Date d'abattage
            const Text(
              'Date d\'abattage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: Text(
                '${_selectedDate.day.toString().padLeft(2, '0')}/'
                '${_selectedDate.month.toString().padLeft(2, '0')}/'
                '${_selectedDate.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 7)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),

            const SizedBox(height: 24),

            // Notes
            const Text(
              'Notes (optionnel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Observations...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les boutons d'action
  Widget _buildActionButtons() {
    final hasBlockedAnimals = _blockedAnimals.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Annuler'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: hasBlockedAnimals ? null : _confirmSlaughter,
            icon: const Icon(Icons.factory),
            label: const Text('Confirmer'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: hasBlockedAnimals ? Colors.grey : Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
