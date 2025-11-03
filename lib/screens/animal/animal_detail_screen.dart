// lib/screens/animal/animal_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import '../../models/animal.dart';
import '../../models/treatment.dart';
import '../../models/weight_record.dart';
import '../../models/animal_extensions.dart';

import '../../providers/animal_provider.dart';
import '../../providers/weight_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/alert_provider.dart';
import '../../models/alert.dart';
import '../../models/alert_type.dart';
import '../../models/alert_category.dart';
import '../../data/mock_data.dart';
import '../../widgets/change_eid_dialog.dart';
import '../../widgets/eid_history_card.dart';
import '../movement/death_screen.dart';
import '../treatment/treatment_screen.dart';

class AnimalDetailScreen extends StatefulWidget {
  final Animal? preloadedAnimal;

  const AnimalDetailScreen({
    Key? key,
    this.preloadedAnimal,
  }) : super(key: key);

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  Animal? _scannedAnimal;
  final _uuid = const Uuid();
  final _random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.preloadedAnimal != null) {
      _scannedAnimal = widget.preloadedAnimal;
    }
  }

  void _simulateScan() {
    final animalProvider = context.read<AnimalProvider>();
    final animals = animalProvider.animals;

    if (animals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun animal disponible'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _scannedAnimal = animals[_random.nextInt(animals.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_scannedAnimal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scanner un Animal')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _simulateScan,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scanner un animal'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_scannedAnimal!.displayName),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.info), text: 'Infos'),
              Tab(icon: Icon(Icons.medical_services), text: 'Soins'),
              Tab(icon: Icon(Icons.family_restroom), text: 'Généalogie'),
            ],
          ),
        ),
        body: Column(
          children: [
            _AnimalHeader(animal: _scannedAnimal!),
            Expanded(
              child: TabBarView(
                children: [
                  _InfosTab(animal: _scannedAnimal!),
                  _SoinsTab(animal: _scannedAnimal!),
                  _GenealogieTab(animal: _scannedAnimal!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimalHeader extends StatelessWidget {
  final Animal animal;

  const _AnimalHeader({required this.animal});

  String _getAgeFormatted() {
    final ageMonths = animal.ageInMonths;
    if (ageMonths < 12) {
      return '$ageMonths mois';
    }
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    return months > 0 ? '$years ans $months mois' : '$years ans';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Row(
        children: [
          Icon(
            animal.sex == AnimalSex.male ? Icons.male : Icons.female,
            size: 32,
            color: animal.sex == AnimalSex.male ? Colors.blue : Colors.pink,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal.displayName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${animal.sex == AnimalSex.male ? '♂️ Mâle' : '♀️ Femelle'} · ${_getAgeFormatted()}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                // ÉTAPE 7 : Afficher Type et Race
                if (animal.hasSpecies)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      animal.fullDisplayFr, // "🐑 Ovin - Mérinos"
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _StatusBadge(status: animal.status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AnimalStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case AnimalStatus.alive:
        color = Colors.green;
        label = '🟢 Vivant';
        break;
      case AnimalStatus.sold:
        color = Colors.orange;
        label = '🟠 Vendu';
        break;
      case AnimalStatus.dead:
        color = Colors.red;
        label = '🔴 Mort';
        break;
      case AnimalStatus.slaughtered:
        color = Colors.red[900]!;
        label = '🔴 Abattu';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}

class _InfosTab extends StatelessWidget {
  final Animal animal;

  const _InfosTab({required this.animal});

  void _showAddWeightDialog(BuildContext context) {
    final weightController = TextEditingController();
    final uuid = const Uuid();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une Pesée'),
        content: TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Poids (kg)',
            suffixText: 'kg',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final weight = double.tryParse(weightController.text);
              if (weight != null && weight > 0) {
                final record = WeightRecord(
                  id: uuid.v4(),
                  animalId: animal.id,
                  weight: weight,
                  recordedAt: DateTime.now(),
                  source: WeightSource.manual,
                  synced: false,
                  createdAt: DateTime.now(),
                );
                context.read<WeightProvider>().addWeight(record);
                context.read<SyncProvider>().incrementPendingData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesée ajoutée')),
                );
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showChangeEidDialog(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (context) => ChangeEidDialog(animal: animal),
    );
    // Note: Pas besoin de setState car le Provider notifiera
    // automatiquement les changements et rebuild les widgets
  }

  String _getAgeFormatted() {
    final ageMonths = animal.ageInMonths;
    if (ageMonths < 12) {
      return '$ageMonths mois';
    }
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    return months > 0 ? '$years ans $months mois' : '$years ans';
  }

  @override
  Widget build(BuildContext context) {
    final animalProvider = context.watch<AnimalProvider>();
    final weightProvider = context.watch<WeightProvider>();

    // Récupérer l'animal à jour depuis le Provider (au cas où il a changé)
    final currentAnimal = animalProvider.getAnimalById(animal.id) ?? animal;

    // Obtenir le dernier poids
    final allWeights = weightProvider.weights
        .where((w) => w.animalId == currentAnimal.id)
        .toList();
    allWeights.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    final latestWeight = allWeights.isNotEmpty ? allWeights.first : null;

    final treatments = animalProvider.getAnimalTreatments(currentAnimal.id);

    bool hasActiveWithdrawal = false;
    for (final treatment in treatments) {
      if (treatment.isWithdrawalActive) {
        hasActiveWithdrawal = true;
        break;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🆕 SECTION ALERTES EN PREMIER
          AlertsSection(animalId: currentAnimal.id),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Informations de base',
            children: [
              _InfoRow(label: 'EID', value: _formatEID(currentAnimal.safeEid)),
              if (currentAnimal.officialNumber != null)
                _InfoRow(
                    label: 'N° Officiel', value: currentAnimal.officialNumber!),
              _InfoRow(
                  label: 'Sexe',
                  value: currentAnimal.sex == AnimalSex.male
                      ? '♂️ Mâle'
                      : '♀️ Femelle'),
              _InfoRow(
                  label: 'Statut',
                  value: _getStatusLabel(currentAnimal.status)),
              _InfoRow(
                  label: 'Date de naissance',
                  value: _formatDate(currentAnimal.birthDate)),
              _InfoRow(label: 'Âge', value: _getAgeFormatted()),
            ],
          ),
          const SizedBox(height: 16),

          // ÉTAPE 7 : Section Type et Race
          if (currentAnimal.hasSpecies)
            _InfoCard(
              title: '🐑 Type et Race',
              children: [
                _InfoRow(
                  label: 'Type',
                  value: currentAnimal.speciesNameFr,
                  icon: currentAnimal.speciesIcon,
                ),
                if (currentAnimal.hasBreed)
                  _InfoRow(
                    label: 'Race',
                    value: currentAnimal.breedNameFr,
                  )
                else
                  _InfoRow(
                    label: 'Race',
                    value: 'Non définie',
                    valueStyle: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

          if (currentAnimal.hasSpecies) const SizedBox(height: 16),

          // NOUVEAU : Section Identification RFID
          _InfoCard(
            title: '🏷️ Identification RFID',
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Changer l\'EID',
              onPressed: () => _showChangeEidDialog(context, currentAnimal),
            ),
            children: [
              _InfoRow(
                label: 'EID actuel',
                value: currentAnimal.safeEid,
              ),
              if (currentAnimal.eidHistory != null &&
                  currentAnimal.eidHistory!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.history,
                            size: 16, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '${currentAnimal.eidHistory!.length} changement(s) enregistré(s)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Historique des changements d'EID (si existant)
          if (currentAnimal.eidHistory != null &&
              currentAnimal.eidHistory!.isNotEmpty) ...[
            EidHistoryCard(history: currentAnimal.eidHistory!),
            const SizedBox(height: 16),
          ],

          _InfoCard(
            title: 'Poids',
            trailing: IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () => _showAddWeightDialog(context),
            ),
            children: [
              if (latestWeight != null) ...[
                Center(
                  child: Column(
                    children: [
                      Text(
                        '${latestWeight.weight.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      Text(
                        'Le ${_formatDate(latestWeight.recordedAt)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ] else
                const Center(child: Text('Aucune pesée enregistrée')),
            ],
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Rémanence',
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      hasActiveWithdrawal ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: hasActiveWithdrawal ? Colors.red : Colors.green,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      hasActiveWithdrawal ? Icons.warning : Icons.check_circle,
                      color: hasActiveWithdrawal ? Colors.red : Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hasActiveWithdrawal
                            ? '⚠️ Ne pas abattre'
                            : '✅ OK pour abattage',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              hasActiveWithdrawal ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddTreatmentDialog(context, currentAnimal.id),
            icon: const Icon(Icons.medical_services),
            label: const Text('Ajouter un soin'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeathScreen()),
              );
            },
            icon: const Icon(Icons.dangerous),
            label: const Text('Déclarer mort'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  String _formatEID(String eid) {
    if (eid.length == 15) {
      return '${eid.substring(0, 3)} ${eid.substring(3, 6)} ${eid.substring(6, 9)} ${eid.substring(9, 12)} ${eid.substring(12)}';
    }
    return eid;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getStatusLabel(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.alive:
        return '🟢 Vivant';
      case AnimalStatus.sold:
        return '🟠 Vendu';
      case AnimalStatus.dead:
        return '🔴 Mort';
      case AnimalStatus.slaughtered:
        return '🔴 Abattu';
    }
  }

  void _showAddTreatmentDialog(BuildContext context, String animalId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TreatmentScreen(animalId: animalId),
      ),
    );
  }
}

class _SoinsTab extends StatelessWidget {
  final Animal animal;

  const _SoinsTab({required this.animal});

  @override
  Widget build(BuildContext context) {
    final animalProvider = context.watch<AnimalProvider>();
    final treatments = animalProvider.getAnimalTreatments(animal.id);

    return Column(
      children: [
        Expanded(
          child: treatments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medical_services,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Aucun soin enregistré',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: treatments.length,
                  itemBuilder: (context, index) {
                    return _TreatmentCard(treatment: treatments[index]);
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TreatmentScreen(animalId: animal.id),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un soin individuel'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
          ),
        ),
      ],
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final Treatment treatment;

  const _TreatmentCard({required this.treatment});

  Color _getWithdrawalBadgeColor() {
    if (!treatment.isWithdrawalActive) {
      return Colors.green;
    }

    final daysRemaining =
        treatment.withdrawalEndDate.difference(DateTime.now()).inDays;

    if (daysRemaining <= 7) {
      return Colors.red;
    } else if (daysRemaining <= 14) {
      return Colors.orange;
    }
    return Colors.blue;
  }

  int _getDaysUntilWithdrawalEnd() {
    return treatment.withdrawalEndDate.difference(DateTime.now()).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final withdrawalColor = _getWithdrawalBadgeColor();
    final daysRemaining = _getDaysUntilWithdrawalEnd();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    treatment.productName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_formatDate(treatment.treatmentDate)),
              ],
            ),
            if (treatment.veterinarianName != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('Dr. ${treatment.veterinarianName}'),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: withdrawalColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: withdrawalColor),
              ),
              child: Text(
                treatment.isWithdrawalActive
                    ? 'Rémanence : ${_formatDate(treatment.withdrawalEndDate)} (${daysRemaining}j)'
                    : '✅ Pas de rémanence',
                style: TextStyle(
                  color: withdrawalColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _GenealogieTab extends StatelessWidget {
  final Animal animal;

  const _GenealogieTab({required this.animal});

  String _getAgeFormatted(Animal animal) {
    final ageMonths = animal.ageInMonths;
    if (ageMonths < 12) {
      return '$ageMonths mois';
    }
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    return months > 0 ? '$years ans $months mois' : '$years ans';
  }

  @override
  Widget build(BuildContext context) {
    final animalProvider = context.watch<AnimalProvider>();
    final mother = animal.motherId != null
        ? animalProvider.getAnimalById(animal.motherId!)
        : null;

    // Obtenir les enfants (seulement via motherId car fatherId n'existe pas dans le modèle)
    final children =
        animalProvider.animals.where((a) => a.motherId == animal.id).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mère',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (mother != null)
            ListTile(
              leading: const Icon(Icons.family_restroom, color: Colors.pink),
              title: Text(mother.displayName),
              subtitle: Text(_getAgeFormatted(mother)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AnimalDetailScreen(preloadedAnimal: mother),
                  ),
                );
              },
              tileColor: Colors.pink[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            )
          else
            const Text('Mère inconnue', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Text('Descendants (${children.length})',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (children.isEmpty)
            const Text('Aucun descendant', style: TextStyle(color: Colors.grey))
          else
            ...children.map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      child.sex == AnimalSex.male ? Icons.male : Icons.female,
                      color: child.sex == AnimalSex.male
                          ? Colors.blue
                          : Colors.pink,
                    ),
                    title: Text(child.displayName),
                    subtitle: Text(_getAgeFormatted(child)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AnimalDetailScreen(preloadedAnimal: child),
                        ),
                      );
                    },
                    tileColor: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                )),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  const _InfoCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                if (trailing != null) trailing!,
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? icon; // ÉTAPE 7 : Support icône
  final TextStyle? valueStyle; // ÉTAPE 7 : Style personnalisé

  const _InfoRow({
    required this.label,
    required this.value,
    this.icon,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Row(
              children: [
                if (icon != null) ...[
                  Text(
                    icon!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: valueStyle ??
                        const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VeterinarianSearchDialog extends StatefulWidget {
  final Function(dynamic) onSelect;

  const _VeterinarianSearchDialog({required this.onSelect});

  @override
  State<_VeterinarianSearchDialog> createState() =>
      _VeterinarianSearchDialogState();
}

class _VeterinarianSearchDialogState extends State<_VeterinarianSearchDialog> {
  final _searchController = TextEditingController();
  List<dynamic> _filteredVets = [];

  @override
  void initState() {
    super.initState();
    _filteredVets = MockData.veterinarians;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterVets(String query) {
    final allVets = MockData.veterinarians;
    setState(() {
      if (query.isEmpty) {
        _filteredVets = allVets;
      } else {
        _filteredVets = allVets.where((vet) {
          return vet.fullName.toLowerCase().contains(query.toLowerCase()) ||
              (vet.clinic?.toLowerCase().contains(query.toLowerCase()) ??
                  false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rechercher un Vétérinaire'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Nom ou établissement...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterVets,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredVets.length,
                itemBuilder: (context, index) {
                  final vet = _filteredVets[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(vet.fullName),
                    subtitle: Text(vet.clinic ?? 'Non spécifié'),
                    onTap: () => widget.onSelect(vet),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler')),
      ],
    );
  }
}

// 🆕 WIDGET ALERTES
class AlertsSection extends StatelessWidget {
  final String animalId;

  const AlertsSection({required this.animalId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, child) {
        final alerts = alertProvider.getAlertsForAnimal(animalId);

        if (alerts.isEmpty) {
          return const SizedBox.shrink();
        }

        final mostUrgent = alerts.first;

        return Card(
          elevation: 3,
          color: _getBackgroundColor(mostUrgent.type),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _getColor(mostUrgent.type),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getIcon(mostUrgent.type),
                      color: _getColor(mostUrgent.type),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        alerts.length == 1
                            ? 'Alerte active'
                            : '${alerts.length} alertes actives',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getColor(mostUrgent.type),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getColor(mostUrgent.type),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getPriorityLabel(mostUrgent.type),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...alerts.map((alert) => _buildAlertItem(alert, context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlertItem(Alert alert, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getColor(alert.type).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _getColor(alert.type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                alert.category.icon,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _getColor(alert.type),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            _getIcon(alert.type),
            color: _getColor(alert.type),
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getColor(AlertType type) {
    switch (type) {
      case AlertType.urgent:
        return Colors.red.shade700;
      case AlertType.important:
        return Colors.orange.shade700;
      case AlertType.routine:
        return Colors.blue.shade700;
    }
  }

  Color _getBackgroundColor(AlertType type) {
    switch (type) {
      case AlertType.urgent:
        return Colors.red.shade50;
      case AlertType.important:
        return Colors.orange.shade50;
      case AlertType.routine:
        return Colors.blue.shade50;
    }
  }

  IconData _getIcon(AlertType type) {
    switch (type) {
      case AlertType.urgent:
        return Icons.error;
      case AlertType.important:
        return Icons.warning_amber;
      case AlertType.routine:
        return Icons.info_outline;
    }
  }

  String _getPriorityLabel(AlertType type) {
    switch (type) {
      case AlertType.urgent:
        return 'URGENT';
      case AlertType.important:
        return 'IMPORTANT';
      case AlertType.routine:
        return 'ROUTINE';
    }
  }
}
