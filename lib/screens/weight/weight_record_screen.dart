// screens/weight_record_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../models/animal.dart';
import '../../models/weight_record.dart';
import '../../providers/animal_provider.dart';
import '../../providers/weight_provider.dart';
import '../../providers/sync_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

/// Écran d'enregistrement d'une nouvelle pesée
class WeightRecordScreen extends StatefulWidget {
  final Animal? preselectedAnimal;

  const WeightRecordScreen({
    super.key,
    this.preselectedAnimal,
  });

  @override
  State<WeightRecordScreen> createState() => _WeightRecordScreenState();
}

class _WeightRecordScreenState extends State<WeightRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  final _random = Random();

  Animal? _selectedAnimal;
  WeightSource _selectedSource = WeightSource.manual;
  DateTime _selectedDate = DateTime.now();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _selectedAnimal = widget.preselectedAnimal;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _scanAnimal() async {
    setState(() => _isScanning = true);

    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 500));

    final animalProvider = context.read<AnimalProvider>();

    try {
      final animals = animalProvider.animals
          .where((a) => a.status == AnimalStatus.alive)
          .toList();

      if (animals.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate(AppStrings.noAnimalsAvailableForWeight)),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isScanning = false);
        return;
      }

      final animal = animals[_random.nextInt(animals.length)];

      setState(() {
        _selectedAnimal = animal;
        _isScanning = false;
      });

      HapticFeedback.heavyImpact();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${AppLocalizations.of(context).translate(AppStrings.animalScanned).replaceAll('{name}', animal.displayName)}',
          ),
          backgroundColor: Colors.green,
          duration: AppConstants.snackBarDurationMedium,
        ),
      );
    } catch (e) {
      setState(() => _isScanning = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.scanError)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveWeight() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAnimal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.selectAnimal)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final weight = double.parse(_weightController.text.trim());

    final weightProvider = context.read<WeightProvider>();
    final syncProvider = context.read<SyncProvider>();

    final record = WeightRecord(
      id: 'weight_${DateTime.now().millisecondsSinceEpoch}',
      animalId: _selectedAnimal!.id,
      weight: weight,
      recordedAt: _selectedDate,
      source: _selectedSource,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      synced: false,
      createdAt: DateTime.now(),
    );

    weightProvider.addWeight(record);
    syncProvider.incrementPendingData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '✅ ${AppLocalizations.of(context).translate(AppStrings.weightRecorded)}: ${weight.toStringAsFixed(1)} ${AppLocalizations.of(context).translate(AppStrings.unitKg)}'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon,
            size: AppConstants.iconSizeRegular, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSectionTitle,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.newWeight)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle(
              context,
              l10n.translate(AppStrings.stepOneAnimal),
              Icons.pets,
            ),
            const SizedBox(height: 12),
            if (_selectedAnimal == null)
              SizedBox(
                height: AppConstants.scanButtonHeight,
                child: ElevatedButton(
                  onPressed: _isScanning ? null : _scanAnimal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: _isScanning
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code_scanner,
                                size: AppConstants.iconSizeExtraLarge),
                            const SizedBox(height: 8),
                            Text(l10n.translate(AppStrings.scanAnimal),
                                style: const TextStyle(
                                    fontSize:
                                        AppConstants.fontSizeSectionTitle)),
                          ],
                        ),
                ),
              )
            else
              Card(
                color: Colors.green.shade50,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _selectedAnimal!.sex == AnimalSex.male
                        ? Colors.blue.shade100
                        : Colors.pink.shade100,
                    child: Icon(
                      _selectedAnimal!.sex == AnimalSex.male
                          ? Icons.male
                          : Icons.female,
                      color: _selectedAnimal!.sex == AnimalSex.male
                          ? Colors.blue
                          : Colors.pink,
                    ),
                  ),
                  title: Text(
                    _selectedAnimal!.officialNumber ??
                        l10n.translate(AppStrings.noNumber),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_selectedAnimal!.displayName),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _selectedAnimal = null;
                      });
                    },
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _buildSectionTitle(
              context,
              l10n
                  .translate(AppStrings.stepTwoWeight)
                  .replaceAll('{weight}', l10n.translate(AppStrings.weight)),
              Icons.monitor_weight,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText:
                    '${l10n.translate(AppStrings.weight)} (${l10n.translate(AppStrings.unitKg)}) *',
                hintText: l10n.translate(AppStrings.weightHintExample),
                prefixIcon: const Icon(Icons.monitor_weight),
                suffixText: l10n.translate(AppStrings.unitKg),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.translate(AppStrings.weightRequired).replaceAll(
                      '{weight}', l10n.translate(AppStrings.weight));
                }
                final weight = double.tryParse(value.trim());
                if (weight == null) {
                  return l10n.translate(AppStrings.invalidWeight).replaceAll(
                      '{weight}', l10n.translate(AppStrings.weight));
                }
                if (weight <= 0 || weight > AppConstants.maxWeightKg) {
                  return l10n.translate(AppStrings.weightRangeError).replaceAll(
                      '{max}', AppConstants.maxWeightKg.toInt().toString());
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(
              context,
              l10n.translate(AppStrings.stepThreeSource),
              Icons.source,
            ),
            const SizedBox(height: 12),
            RadioGroup<WeightSource>(
              groupValue: _selectedSource,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSource = value;
                  });
                }
              },
              child: Column(
                children: WeightSource.values.map((source) {
                  return RadioListTile<WeightSource>(
                    value: source,
                    title: Row(
                      children: [
                        Text(source.icon),
                        const SizedBox(width: 8),
                        Text(source.getLocalizedName(context)),
                      ],
                    ),
                    subtitle: Text(
                      l10n.translate(AppStrings.reliability).replaceAll(
                          '{percent}',
                          (source.reliability * 100).toInt().toString()),
                      style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: Colors.grey.shade600),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(
              context,
              l10n
                  .translate(AppStrings.stepFourDate)
                  .replaceAll('{date}', l10n.translate(AppStrings.selectDate)),
              Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(l10n.translate(AppStrings.selectDate)),
              subtitle: Text(_formatDate(_selectedDate)),
              trailing: const Icon(Icons.edit),
              onTap: _selectDate,
              tileColor: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(
              context,
              l10n
                  .translate(AppStrings.stepFiveNotes)
                  .replaceAll('{notes}', l10n.translate(AppStrings.notes))
                  .replaceAll(
                      '{optional}', l10n.translate(AppStrings.optional)),
              Icons.notes,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.notes),
                hintText: l10n.translate(AppStrings.notesHintWeight),
                prefixIcon: const Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: AppConstants.primaryButtonHeight,
              child: ElevatedButton.icon(
                onPressed: _saveWeight,
                icon: const Icon(Icons.save),
                label: Text(l10n.translate(AppStrings.save)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: AppConstants.fontSizeSectionTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.translate(AppStrings.cancel)),
            ),
          ],
        ),
      ),
    );
  }
}
