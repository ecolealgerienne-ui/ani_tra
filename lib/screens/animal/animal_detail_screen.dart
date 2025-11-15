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
import '../../providers/vaccination_provider.dart';
import '../../models/alert.dart';
import '../../models/alert_type.dart';
import '../../models/alert_category.dart';
import '../../models/vaccination.dart';
import '../../data/mock_data.dart';
import '../../widgets/change_eid_dialog.dart';
import '../../widgets/eid_history_card.dart';
import '../movement/death_screen.dart';
//import '../treatment/0_treatment_screen.dart';
import '../vaccination/vaccination_detail_screen.dart';
import '../medical/medical_act_screen.dart';
import 'add_animal_screen.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

class AnimalDetailScreen extends StatefulWidget {
  final Animal? preloadedAnimal;

  const AnimalDetailScreen({
    super.key,
    this.preloadedAnimal,
  });

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
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate(AppStrings.noAnimalAvailable)),
          backgroundColor: AppConstants.warningOrange,
        ),
      );
      return;
    }

    setState(() {
      _scannedAnimal = animals[_random.nextInt(animals.length)];
    });
  }

  // ✅ NOUVELLE MÉTHODE: Recharger l'animal après le retour de DeathScreen
  void _reloadAnimalAfterDeath() {
    final updatedAnimal =
        context.read<AnimalProvider>().getAnimalById(_scannedAnimal!.id);

    if (updatedAnimal != null) {
      setState(() {
        _scannedAnimal = updatedAnimal;
      });
      debugPrint('✅ Animal reloaded: ${updatedAnimal.status}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_scannedAnimal == null) {
      return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)
                .translate(AppStrings.animalDetail))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey[400]),
              const SizedBox(height: AppConstants.spacingMediumLarge),
              ElevatedButton.icon(
                onPressed: _simulateScan,
                icon: const Icon(Icons.camera_alt),
                label: Text(AppLocalizations.of(context)
                    .translate(AppStrings.scanAnimal)),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: TabBar(
              onTap: (index) {
                // ✅ Empêcher de cliquer sur Tab "Soins" si DRAFT
                if (index == 1 && _scannedAnimal!.isDraft) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .translate(AppStrings.notAvailableDraft)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              tabs: [
                Tab(
                  icon: const Icon(Icons.info),
                  text:
                      AppLocalizations.of(context).translate(AppStrings.infos),
                ),
                Tab(
                  icon: const Icon(Icons.medical_services),
                  text: AppLocalizations.of(context).translate(AppStrings.care),
                ),
                Tab(
                  icon: const Icon(Icons.family_restroom),
                  text: AppLocalizations.of(context)
                      .translate(AppStrings.genealogy),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            _AnimalHeader(animal: _scannedAnimal!),
            Expanded(
              child: TabBarView(
                children: [
                  _InfosTab(animal: _scannedAnimal!),
                  _SoinsTab(
                    animal: _scannedAnimal!,
                    onDeathScreenReturn: _reloadAnimalAfterDeath,
                  ),
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
    final maleLabel = AppLocalizations.of(context).translate(AppStrings.male);
    final femaleLabel =
        AppLocalizations.of(context).translate(AppStrings.female);
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      color: Colors.blue[50],
      child: Row(
        children: [
          Icon(
            animal.sex == AnimalSex.male ? Icons.male : Icons.female,
            size: AppConstants.iconSizeMedium,
            color: animal.sex == AnimalSex.male ? Colors.blue : Colors.pink,
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal.displayName,
                  style: const TextStyle(
                      fontSize: AppConstants.fontSizeImportant, fontWeight: FontWeight.bold),
                ),

                Text(
                  '${animal.sex == AnimalSex.male ? '♂️ $maleLabel' : '♀️ $femaleLabel'} · ${_getAgeFormatted()}',
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
                        fontSize: AppConstants.fontSizeSubtitle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _StatusBadge(animalId: animal.id),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String animalId; // ← Changer de 'status' à 'animalId'

  const _StatusBadge({required this.animalId});

  @override
  Widget build(BuildContext context) {
    // ✅ Récupérer l'animal FRAIS du provider
    final animalProvider = context.watch<AnimalProvider>();
    final animal = animalProvider.getAnimalById(animalId);

    if (animal == null) {
      return const SizedBox.shrink();
    }

    final status = animal.status;
    Color color;
    String label;

    switch (status) {
      case AnimalStatus.draft:
        color = Colors.amber;
        label = AppLocalizations.of(context).translate(AppStrings.draftStatus);
        break;
      case AnimalStatus.alive:
        color = AppConstants.successGreen;
        label = AppLocalizations.of(context).translate(AppStrings.statusAlive);
        break;
      case AnimalStatus.sold:
        color = AppConstants.warningOrange;
        label = AppLocalizations.of(context).translate(AppStrings.statusSold);
        break;
      case AnimalStatus.dead:
        color = AppConstants.statusDanger;
        label = AppLocalizations.of(context).translate(AppStrings.statusDead);
        break;
      case AnimalStatus.slaughtered:
        color = Colors.red[900]!;
        label = AppLocalizations.of(context)
            .translate(AppStrings.statusSlaughtered);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingSmall, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppConstants.opacityMedium),
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
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
        title: Text(
            AppLocalizations.of(context).translate(AppStrings.animalDetail)),
        content: TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate(AppStrings.weightInKg),
            suffixText: AppLocalizations.of(context).translate(AppStrings.kg),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
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
                  SnackBar(content: Text(AppLocalizations.of(context).translate(AppStrings.weightAddedMessage))),
                );
              }
            },
            child: Text(AppLocalizations.of(context).translate(AppStrings.save)),
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

  /// Afficher le dialog d'édition des notes
  void _showEditNotesDialog(BuildContext context, Animal animal) {
    final notesController = TextEditingController(text: animal.notes ?? '');

    showDialog(
      context: context,
      builder: (context) => _EditNotesDialog(
        animal: animal,
        notesController: notesController,
      ),
    );
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
    //final currentAnimal = animalProvider.getAnimalById(animal.id) ?? animal;
    final currentAnimal =
        context.watch<AnimalProvider>().getAnimalById(animal.id) ?? animal;

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
    final maleLabel = AppLocalizations.of(context).translate(AppStrings.male);
    final femaleLabel =
        AppLocalizations.of(context).translate(AppStrings.female);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🚨 BANNIÈRE DRAFT
          if (currentAnimal.isDraft) ...[
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingSmall),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber, width: AppConstants.spacingMicro),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.amber.shade700),
                  const SizedBox(width: AppConstants.spacingExtraSmall),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).translate(AppStrings.draftModeBanner),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 🆕 SECTION ALERTES EN PREMIER
          AlertsSection(animalId: currentAnimal.id),
          const SizedBox(height: AppConstants.spacingMedium),
          _InfoCard(
            title: AppLocalizations.of(context).translate(AppStrings.basicInformation),
            children: [
              _InfoRow(label: AppLocalizations.of(context).translate(AppStrings.eid), value: _formatEID(currentAnimal.safeEid)),
              if (currentAnimal.visualId != null &&
                  currentAnimal.visualId!.isNotEmpty)
                _InfoRow(label: AppLocalizations.of(context).translate(AppStrings.visualId), value: currentAnimal.visualId!),
              if (currentAnimal.officialNumber != null)
                _InfoRow(
                    label: AppLocalizations.of(context).translate(AppStrings.officialNumber), value: currentAnimal.officialNumber!),
              _InfoRow(
                label: AppLocalizations.of(context).translate(AppStrings.sex),
                value: currentAnimal.sex == AnimalSex.male
                    ? '♂️ $maleLabel'
                    : '♀️ $femaleLabel',
              ),
              _InfoRow(
                  label: AppLocalizations.of(context)
                      .translate(AppStrings.statusAnimal),
                  value: () {
                    switch (currentAnimal.status) {
                      case AnimalStatus.draft:
                        return AppLocalizations.of(context)
                            .translate(AppStrings.draftStatus);
                      case AnimalStatus.alive:
                        return AppLocalizations.of(context)
                            .translate(AppStrings.statusAlive);
                      case AnimalStatus.sold:
                        return AppLocalizations.of(context)
                            .translate(AppStrings.statusSold);
                      case AnimalStatus.dead:
                        return AppLocalizations.of(context)
                            .translate(AppStrings.statusDead);
                      case AnimalStatus.slaughtered:
                        return AppLocalizations.of(context)
                            .translate(AppStrings.statusSlaughtered);
                    }
                  }()),
              _InfoRow(
                  label: AppLocalizations.of(context)
                      .translate(AppStrings.birthDate),
                  value: _formatDate(currentAnimal.birthDate)),
              _InfoRow(label: AppLocalizations.of(context).translate(AppStrings.age), value: _getAgeFormatted()),
              _InfoRow(
                label: AppLocalizations.of(context).translate(AppStrings.createdOn),
                value: _formatDate(currentAnimal.createdAt),
              ),
              if (currentAnimal.validatedAt != null)
                _InfoRow(
                  label: AppLocalizations.of(context).translate(AppStrings.validatedOn),
                  value: _formatDate(currentAnimal.validatedAt!),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          // ÉTAPE 7 : Section Type et Race
          if (currentAnimal.hasSpecies)
            _InfoCard(
              title: AppLocalizations.of(context).translate(AppStrings.typeAndBreedSection),
              children: [
                _InfoRow(
                  label: AppLocalizations.of(context)
                      .translate(AppStrings.species),
                  value: currentAnimal.speciesNameFr,
                  icon: currentAnimal.speciesIcon,
                ),
                if (currentAnimal.hasBreed)
                  _InfoRow(
                    label: AppLocalizations.of(context)
                        .translate(AppStrings.breed),
                    value: currentAnimal.breedNameFr,
                  )
                else
                  _InfoRow(
                    label: AppLocalizations.of(context)
                        .translate(AppStrings.breed),
                    value: AppLocalizations.of(context).translate(AppStrings.notDefined),
                    valueStyle: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

          if (currentAnimal.hasSpecies) const SizedBox(height: AppConstants.spacingMedium),

          // NOUVEAU : Section Identification RFID
          _InfoCard(
            title: AppLocalizations.of(context).translate(AppStrings.rfidIdentification),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              tooltip:
                  AppLocalizations.of(context).translate(AppStrings.changeEid),
              onPressed: () => _showChangeEidDialog(context, currentAnimal),
            ),
            children: [
              _InfoRow(
                label: AppLocalizations.of(context)
                    .translate(AppStrings.currentEid),
                value: currentAnimal.safeEid,
              ),
              if (currentAnimal.eidHistory != null &&
                  currentAnimal.eidHistory!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.spacingExtraSmall),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusTiny),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.history,
                            size: AppConstants.iconSizeXSmall, color: Colors.blue.shade700),
                        const SizedBox(width: AppConstants.spacingExtraSmall),
                        Text(
                          '${currentAnimal.eidHistory!.length} ${AppLocalizations.of(context).translate(AppStrings.eidChangesRecorded)}',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          // Historique des changements d'EID (si existant)
          if (currentAnimal.eidHistory != null &&
              currentAnimal.eidHistory!.isNotEmpty) ...[
            EidHistoryCard(history: currentAnimal.eidHistory!),
            const SizedBox(height: AppConstants.spacingMedium),
          ],

          // Section Notes
          _InfoCard(
            title: AppLocalizations.of(context).translate(AppStrings.notes),
            trailing: (currentAnimal.isDraft || currentAnimal.status == AnimalStatus.alive)
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: AppLocalizations.of(context).translate(AppStrings.editNotes),
                    onPressed: () => _showEditNotesDialog(context, currentAnimal),
                  )
                : null,
            children: [
              _InfoRow(
                label: '',
                value: currentAnimal.hasNotes
                    ? currentAnimal.notes!
                    : AppLocalizations.of(context).translate(AppStrings.noNotes),
                valueStyle: TextStyle(
                  color: currentAnimal.hasNotes ? Colors.black87 : Colors.grey,
                  fontStyle: currentAnimal.hasNotes ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          _InfoCard(
            title: AppLocalizations.of(context).translate(AppStrings.weight),
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
                        '${AppLocalizations.of(context).translate(AppStrings.on)} ${_formatDate(latestWeight.recordedAt)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ] else
                Center(
                    child: Text(AppLocalizations.of(context)
                        .translate(AppStrings.noWeightRecorded))),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          _InfoCard(
            title: AppLocalizations.of(context).translate(AppStrings.withdrawal),
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSmall),
                decoration: BoxDecoration(
                  color:
                      hasActiveWithdrawal ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(
                    color: hasActiveWithdrawal ? Colors.red : Colors.green,
                    width: AppConstants.spacingMicro,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      hasActiveWithdrawal ? Icons.warning : Icons.check_circle,
                      color: hasActiveWithdrawal ? Colors.red : Colors.green,
                      size: AppConstants.iconSizeMedium,
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(
                      child: Text(
                        hasActiveWithdrawal
                            ? AppLocalizations.of(context).translate(AppStrings.doNotSlaughter)
                            : AppLocalizations.of(context).translate(AppStrings.okForSlaughter),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
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
          const SizedBox(height: AppConstants.spacingMedium),
          // ✅ Invisible si DRAFT
          if (!currentAnimal.isDraft)
            OutlinedButton.icon(
              onPressed: currentAnimal.status == AnimalStatus.dead
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DeathScreen(animal: currentAnimal)),
                      );
                    },
              icon: const Icon(Icons.dangerous),
              label: Text(AppLocalizations.of(context)
                  .translate(AppStrings.declareDeath)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: currentAnimal.status == AnimalStatus.dead
                    ? Colors.grey
                    : Colors.red,
              ),
            ),

          // ✅ BOUTONS DRAFT (Modifier, Valider, Supprimer)
          if (currentAnimal.isDraft) ...[
            const SizedBox(height: AppConstants.spacingMediumLarge),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: const Border(
                    top: BorderSide(color: Colors.amber, width: 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bouton Modifier → Naviguer vers AddAnimalScreen en mode édition
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddAnimalScreen(editingAnimal: currentAnimal),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: Text('✏️ ${AppLocalizations.of(context).translate(AppStrings.modify)}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingExtraSmall),

                  // Bouton Valider
                  ElevatedButton.icon(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(AppLocalizations.of(context).translate(AppStrings.validateAnimalTitle)),
                          content: Text(AppLocalizations.of(context).translate(AppStrings.validateAnimalConfirm)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context
                                    .read<AnimalProvider>()
                                    .validateAnimal(currentAnimal.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(AppLocalizations.of(context).translate(AppStrings.animalValidatedSuccess))),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text(AppLocalizations.of(context).translate(AppStrings.validate)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: Text('✅ ${AppLocalizations.of(context).translate(AppStrings.validate)}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingExtraSmall),

                  // Bouton Supprimer
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(AppLocalizations.of(context).translate(AppStrings.deleteAnimalTitle)),
                          content: Text(AppLocalizations.of(context).translate(AppStrings.deleteAnimalConfirm)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context
                                    .read<AnimalProvider>()
                                    .deleteAnimal(currentAnimal.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(AppLocalizations.of(context).translate(AppStrings.animalDeletedSuccess))),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(AppLocalizations.of(context).translate(AppStrings.delete)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: Text('🗑️ ${AppLocalizations.of(context).translate(AppStrings.delete)}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  // void _showAddTreatmentDialog(BuildContext context, String animalId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => TreatmentScreen(animalId: animalId),
  //     ),
  //   );
  // }
}

class _SoinsTab extends StatelessWidget {
  final Animal animal;
  final VoidCallback? onDeathScreenReturn;

  const _SoinsTab({
    required this.animal,
    this.onDeathScreenReturn,
  });

  @override
  Widget build(BuildContext context) {
    final animalProvider = context.watch<AnimalProvider>();
    final vaccinationProvider = context.watch<VaccinationProvider>();
    final treatments = animalProvider.getAnimalTreatments(animal.id);
    final vaccinations =
        vaccinationProvider.getVaccinationsForAnimal(animal.id);

    return Column(
      children: [
        Expanded(
          child: (treatments.isEmpty && vaccinations.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medical_services,
                          size: AppConstants.iconSizeLarge, color: Colors.grey[400]),
                      const SizedBox(height: AppConstants.spacingMedium),
                      Text(AppLocalizations.of(context).translate(AppStrings.noCareRecorded),
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppConstants.spacingMedium),
                  children: [
                    if (vaccinations.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.vaccines,
                              color: Colors.green, size: AppConstants.iconSizeRegular),
                          const SizedBox(width: AppConstants.spacingExtraSmall),
                          Text(
                            AppLocalizations.of(context)
                                .translate(AppStrings.vaccinations),
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${vaccinations.length}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeBody,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingExtraSmall),
                      ...vaccinations
                          .map((v) => _VaccinationCard(vaccination: v)),
                      const SizedBox(height: AppConstants.spacingMediumLarge),
                    ],
                    if (treatments.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.medical_services,
                              color: Colors.blue, size: AppConstants.iconSizeRegular),
                          const SizedBox(width: AppConstants.spacingExtraSmall),
                          Text(
                            AppLocalizations.of(context).translate(AppStrings.treatments),
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${treatments.length}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeBody,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingExtraSmall),
                      ...treatments.map((t) => _TreatmentCard(treatment: t)),
                    ],
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: ElevatedButton.icon(
            onPressed: animal.canReceiveCare
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicalActScreen(
                            mode: MedicalActMode.singleAnimal,
                            animalId: animal.id),
                      ),
                    ).then((_) {
                      onDeathScreenReturn?.call();
                    });
                  }
                : null,
            icon: const Icon(Icons.medical_services),
            label: Text(AppLocalizations.of(context).translate(AppStrings.treat)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: animal.canReceiveCare
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade400,
              foregroundColor: Colors.white,
            ),
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
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: Colors.blue),
                const SizedBox(width: AppConstants.spacingExtraSmall),
                Expanded(
                  child: Text(
                    treatment.productName,
                    style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: AppConstants.iconSizeXSmall, color: Colors.grey),
                const SizedBox(width: AppConstants.spacingTiny),
                Text(_formatDate(treatment.treatmentDate)),
              ],
            ),
            if (treatment.veterinarianName != null) ...[
              const SizedBox(height: AppConstants.spacingTiny),
              Row(
                children: [
                  const Icon(Icons.person, size: AppConstants.iconSizeXSmall, color: Colors.grey),
                  const SizedBox(width: AppConstants.spacingTiny),
                  Text('${AppLocalizations.of(context).translate(AppStrings.drPrefix)}${treatment.veterinarianName}'),
                ],
              ),
            ],
            const SizedBox(height: AppConstants.spacingExtraSmall),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: withdrawalColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusTiny),
                border: Border.all(color: withdrawalColor),
              ),
              child: Text(
                treatment.isWithdrawalActive
                    ? '${AppLocalizations.of(context).translate(AppStrings.withdrawalLabel)}${_formatDate(treatment.withdrawalEndDate)} (${daysRemaining}j)'
                    : AppLocalizations.of(context).translate(AppStrings.noWithdrawal),
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

  String _getAgeFormatted(Animal animal, BuildContext context) {
    final ageMonths = animal.ageInMonths;
    if (ageMonths < 12) {
      return '$ageMonths ${AppLocalizations.of(context).translate(AppStrings.months)}';
    }
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    final yearsLabel = AppLocalizations.of(context).translate(AppStrings.years);
    final monthsLabel = AppLocalizations.of(context).translate(AppStrings.months);
    return months > 0 ? '$years $yearsLabel $months $monthsLabel' : '$years $yearsLabel';
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
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).translate(AppStrings.mother),
              style:
                  const TextStyle(fontSize: AppConstants.fontSizeImportant, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.spacingExtraSmall),
          if (mother != null)
            ListTile(
              leading: const Icon(Icons.family_restroom, color: Colors.pink),
              title: Text(mother.displayName),
              subtitle: Text(_getAgeFormatted(mother, context)),
              trailing: const Icon(Icons.arrow_forward_ios, size: AppConstants.iconSizeXSmall),
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
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
            )
          else
            const Text('Mère inconnue', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: AppConstants.spacingMediumLarge),
          Text('Descendants (${children.length})',
              style:
                  const TextStyle(fontSize: AppConstants.fontSizeImportant, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.spacingExtraSmall),
          if (children.isEmpty)
            Text(AppLocalizations.of(context).translate(AppStrings.noOffspring), style: const TextStyle(color: Colors.grey))
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
                    subtitle: Text(_getAgeFormatted(child, context)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: AppConstants.iconSizeXSmall),
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
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
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
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: AppConstants.fontSizeImportant, fontWeight: FontWeight.bold)),
                if (trailing != null) trailing!,
              ],
            ),
            const Divider(height: AppConstants.spacingMediumLarge),
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
                    style: const TextStyle(fontSize: AppConstants.fontSizeImportant),
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
      title:
          Text(AppLocalizations.of(context).translate(AppStrings.animalDetail)),
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
            const SizedBox(height: AppConstants.spacingMedium),
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
            child: Text(
                AppLocalizations.of(context).translate(AppStrings.cancel))),
      ],
    );
  }
}

// 🆕 WIDGET ALERTES
class AlertsSection extends StatelessWidget {
  final String animalId;

  const AlertsSection({super.key, required this.animalId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, child) {
        final alerts = alertProvider.getSpecificAlertsForAnimal(animalId);

        if (alerts.isEmpty) {
          return const SizedBox.shrink();
        }

        final mostUrgent = alerts.first;

        return Card(
          elevation: 3,
          color: _getBackgroundColor(mostUrgent.type),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
            side: BorderSide(
              color: _getColor(mostUrgent.type),
              width: AppConstants.spacingMicro,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getIcon(mostUrgent.type),
                      color: _getColor(mostUrgent.type),
                      size: AppConstants.iconSizeMedium,
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(
                      child: Text(
                        alerts.length == 1
                            ? AppLocalizations.of(context).translate(AppStrings.activeAlert)
                            : '${alerts.length} ${AppLocalizations.of(context).translate(AppStrings.activeAlerts)}',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeImportant,
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
                        _getPriorityLabel(context, mostUrgent.type),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingMedium),
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
      padding: const EdgeInsets.all(AppConstants.spacingSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
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
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Center(
              child: Text(
                alert.category.icon,
                style: const TextStyle(fontSize: AppConstants.fontSizeImportant),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.getTitle(context),
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLabel,
                    fontWeight: FontWeight.w600,
                    color: _getColor(alert.type),
                  ),
                ),
                // ✅ PHASE 4 FIX: Afficher le message aussi
                if (alert.message.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spacingTiny),
                  Text(
                    alert.getMessage(context),
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSubtitle,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            _getIcon(alert.type),
            color: _getColor(alert.type),
            size: AppConstants.iconSizeRegular,
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

  String _getPriorityLabel(BuildContext context, AlertType type) {
    switch (type) {
      case AlertType.urgent:
        return AppLocalizations.of(context).translate(AppStrings.priorityUrgent);
      case AlertType.important:
        return AppLocalizations.of(context).translate(AppStrings.priorityImportant);
      case AlertType.routine:
        return AppLocalizations.of(context).translate(AppStrings.priorityRoutine);
    }
  }
}

class _VaccinationCard extends StatelessWidget {
  final Vaccination vaccination;

  const _VaccinationCard({required this.vaccination});

  Color _getTypeColor() {
    switch (vaccination.type) {
      case VaccinationType.obligatoire:
        return Colors.red;
      case VaccinationType.recommandee:
        return Colors.orange;
      case VaccinationType.optionnelle:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VaccinationDetailScreen(vaccination: vaccination),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.vaccines, color: Colors.green),
                  const SizedBox(width: AppConstants.spacingExtraSmall),
                  Expanded(
                    child: Text(
                      vaccination.vaccineName,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusTiny),
                    ),
                    child: Text(
                      vaccination.type.label,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeTiny,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingExtraSmall),
              Row(
                children: [
                  const Icon(Icons.medical_services,
                      size: AppConstants.iconSizeTiny, color: Colors.grey),
                  const SizedBox(width: AppConstants.spacingTiny),
                  Text(
                    vaccination.disease,
                    style: TextStyle(fontSize: AppConstants.fontSizeSubtitle, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingTiny),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: AppConstants.iconSizeTiny, color: Colors.grey),
                  const SizedBox(width: AppConstants.spacingTiny),
                  Text(
                    _formatDate(vaccination.vaccinationDate),
                    style: TextStyle(fontSize: AppConstants.fontSizeSubtitle, color: Colors.grey[700]),
                  ),
                ],
              ),
              if (vaccination.nextDueDate != null) ...[
                const SizedBox(height: AppConstants.spacingExtraSmall),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: vaccination.isReminderDue
                        ? (vaccination.daysUntilReminder! < 0
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1))
                        : Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusTiny),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        vaccination.daysUntilReminder! < 0
                            ? Icons.error
                            : Icons.notifications,
                        size: AppConstants.iconSizeTiny,
                        color: vaccination.isReminderDue
                            ? (vaccination.daysUntilReminder! < 0
                                ? Colors.red
                                : Colors.orange)
                            : Colors.blue,
                      ),
                      const SizedBox(width: AppConstants.spacingTiny),
                      Text(
                        vaccination.daysUntilReminder! < 0
                            ? AppLocalizations.of(context)
                                .translate(AppStrings.reminderLate)
                            : AppLocalizations.of(context)
                                .translate(AppStrings.reminderInDays)
                                .replaceAll('{days}',
                                    '${vaccination.daysUntilReminder}'),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: vaccination.isReminderDue
                              ? (vaccination.daysUntilReminder! < 0
                                  ? Colors.red
                                  : Colors.orange)
                              : Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== EDIT NOTES DIALOG ====================

class _EditNotesDialog extends StatefulWidget {
  final Animal animal;
  final TextEditingController notesController;

  const _EditNotesDialog({
    required this.animal,
    required this.notesController,
  });

  @override
  State<_EditNotesDialog> createState() => _EditNotesDialogState();
}

class _EditNotesDialogState extends State<_EditNotesDialog> {
  static const int maxLength = 1000;
  bool _isSaving = false;

  @override
  void dispose() {
    widget.notesController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes() async {
    setState(() => _isSaving = true);

    try {
      final animalProvider = context.read<AnimalProvider>();
      final updatedAnimal = widget.animal.copyWith(
        notes: widget.notesController.text.trim().isEmpty
            ? null
            : widget.notesController.text.trim(),
      );

      await animalProvider.updateAnimal(updatedAnimal);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate(AppStrings.notesSaved),
            ),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.errorOccurred)
                  .replaceAll('{error}', e.toString()),
            ),
            backgroundColor: AppConstants.statusDanger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate(AppStrings.editNotes)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisStart,
          children: [
            TextField(
              controller: widget.notesController,
              maxLength: maxLength,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.notesPlaceholder),
                border: const OutlineInputBorder(),
                helperText: AppLocalizations.of(context)
                    .translate(AppStrings.notesMaxLength),
              ),
              enabled: !_isSaving,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveNotes,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.successGreen,
            foregroundColor: Colors.white,
          ),
          child: _isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.save, size: 18),
                    const SizedBox(width: 4),
                    Text(AppLocalizations.of(context).translate(AppStrings.save)),
                  ],
                ),
        ),
      ],
    );
  }
}
