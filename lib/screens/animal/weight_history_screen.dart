// lib/screens/animal/weight_history_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../drift/database.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../models/animal.dart';
import '../../models/weight_record.dart';
import '../../providers/weight_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';

/// Écran d'historique des poids pour un animal
///
/// Affiche les 10 derniers poids triés du plus récent au plus ancien
/// Permet d'ajouter un nouveau poids via un FloatingActionButton
class WeightHistoryScreen extends StatefulWidget {
  final Animal animal;

  const WeightHistoryScreen({
    super.key,
    required this.animal,
  });

  @override
  State<WeightHistoryScreen> createState() => _WeightHistoryScreenState();
}

class _WeightHistoryScreenState extends State<WeightHistoryScreen> {
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _recordedAt = DateTime.now();
  String _source = 'scale'; // balance par défaut

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _showAddWeightDialog() async {
    // Reset form
    _weightController.clear();
    _notesController.clear();
    _recordedAt = DateTime.now();
    _source = 'scale';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

          return AlertDialog(
            title: Text(
              AppLocalizations.of(context).translate(AppStrings.addWeight),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Poids
                  TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context).translate(AppStrings.weight)} (kg)',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.monitor_weight),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),

                  // Date de pesée
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    leading: const Icon(Icons.calendar_today),
                    title: Text(AppLocalizations.of(context).translate(AppStrings.selectDate)),
                    subtitle: Text(dateFormat.format(_recordedAt)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _recordedAt,
                        firstDate: DateTime.now().subtract(const Duration(days: AppConstants.maxPastDays)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setDialogState(() => _recordedAt = date);
                      }
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),

                  // Source de mesure
                  DropdownButtonFormField<String>(
                    value: _source,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate(AppStrings.weightSource),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.source),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'scale',
                        child: Text(AppLocalizations.of(context).translate(AppStrings.weightSourceScale)),
                      ),
                      DropdownMenuItem(
                        value: 'manual',
                        child: Text(AppLocalizations.of(context).translate(AppStrings.weightSourceManual)),
                      ),
                      DropdownMenuItem(
                        value: 'estimated',
                        child: Text(AppLocalizations.of(context).translate(AppStrings.weightSourceEstimated)),
                      ),
                      DropdownMenuItem(
                        value: 'veterinary',
                        child: Text(AppLocalizations.of(context).translate(AppStrings.weightSourceVeterinary)),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => _source = value);
                      }
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),

                  // Notes (optionnel)
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate(AppStrings.notes),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.note),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
              ),
              FilledButton(
                onPressed: () {
                  if (_weightController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).translate(AppStrings.fillAllFields),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, true);
                },
                child: Text(AppLocalizations.of(context).translate(AppStrings.save)),
              ),
            ],
          );
        },
      ),
    );

    if (result == true && mounted) {
      await _addWeight();
    }
  }

  Future<void> _addWeight() async {
    final weightValue = double.tryParse(_weightController.text);
    if (weightValue == null || weightValue <= 0) return;

    final weightProvider = context.read<WeightProvider>();
    final syncProvider = context.read<SyncProvider>();
    final farmId = context.read<AuthProvider>().currentFarmId;

    try {
      final weightRecord = WeightRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        farmId: farmId,
        animalId: widget.animal.id,
        weight: weightValue,
        recordedAt: _recordedAt,
        source: _source,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        createdAt: DateTime.now(),
      );

      await weightProvider.addWeight(weightRecord);
      syncProvider.incrementPendingData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate(AppStrings.weightRecorded),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate(AppStrings.error),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final farmId = context.watch<AuthProvider>().currentFarmId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate(AppStrings.weightHistory),
        ),
      ),
      body: StreamBuilder<List<WeightsTableData>>(
        stream: db.weightDao.getLatest10ByAnimal(farmId, widget.animal.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(context).translate(AppStrings.error),
              ),
            );
          }

          final weights = snapshot.data ?? [];

          if (weights.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monitor_weight_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: AppConstants.spacingMedium),
                  Text(
                    AppLocalizations.of(context).translate(AppStrings.noWeightsRecorded),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            itemCount: weights.length,
            itemBuilder: (context, index) {
              final weight = weights[index];
              final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

              // Calculer la différence avec le poids précédent si disponible
              String? weightDiff;
              if (index < weights.length - 1) {
                final prevWeight = weights[index + 1].weight;
                final diff = weight.weight - prevWeight;
                final percentDiff = (diff / prevWeight) * 100;
                weightDiff = '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)}kg (${percentDiff.toStringAsFixed(1)}%)';
              }

              return Card(
                margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.monitor_weight, color: Colors.white),
                  ),
                  title: Text(
                    '${weight.weight.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateFormat.format(weight.recordedAt)),
                      Text('Source: ${weight.source}'),
                      if (weightDiff != null)
                        Text(
                          weightDiff,
                          style: TextStyle(
                            color: weightDiff.startsWith('-') ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (weight.notes != null && weight.notes!.isNotEmpty)
                        Text(
                          weight.notes!,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                  trailing: index == 0
                      ? const Chip(
                          label: Text('Plus récent', style: TextStyle(fontSize: 10)),
                          backgroundColor: Colors.blue,
                          labelStyle: TextStyle(color: Colors.white),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWeightDialog,
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context).translate(AppStrings.addWeight)),
      ),
    );
  }
}
