// lib/screens/treatment/treatment_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/treatment_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/treatment.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

class TreatmentDetailScreen extends StatelessWidget {
  final Treatment treatment;

  const TreatmentDetailScreen({
    super.key,
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.treatmentDetail)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            _buildInfoCard(context),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            _buildWithdrawalCard(context),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            _buildAnimalCard(context),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            _buildNotesCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.medical_services,
                  color: Colors.blue,
                  size: AppConstants.iconSizeMedium,
                ),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: Text(
                    treatment.productName,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeImportant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Row(
              children: [
                Icon(Icons.science, size: AppConstants.iconSizeXSmall, color: Colors.grey[600]),
                const SizedBox(width: AppConstants.spacingTiny),
                Text(
                  '${l10n.translate(AppStrings.dosage)}: ${treatment.dose.toStringAsFixed(1)} ml',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate(AppStrings.treatmentInformation),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: AppConstants.spacingMediumLarge),
            _buildInfoRow(
              context,
              Icons.calendar_today,
              l10n.translate(AppStrings.date),
              _formatDate(treatment.treatmentDate),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            if (treatment.veterinarianName != null)
              _buildInfoRow(
                context,
                Icons.person,
                l10n.translate(AppStrings.veterinarian),
                '${l10n.translate(AppStrings.drPrefix)}${treatment.veterinarianName}',
              ),
            if (treatment.veterinarianName != null)
              const SizedBox(height: AppConstants.spacingSmall),
            _buildInfoRow(
              context,
              Icons.access_time,
              l10n.translate(AppStrings.recordedOn),
              _formatDateTime(treatment.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawalCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isActive = treatment.isWithdrawalActive;
    final daysRemaining = treatment.daysUntilWithdrawalEnd;

    Color color;
    IconData icon;
    String message;

    if (isActive) {
      if (daysRemaining <= 7) {
        color = Colors.red;
        icon = Icons.error;
      } else if (daysRemaining <= 14) {
        color = Colors.orange;
        icon = Icons.warning_amber;
      } else {
        color = Colors.blue;
        icon = Icons.info_outline;
      }
      message = l10n
          .translate(AppStrings.withdrawalActiveUntil)
          .replaceAll('{date}', _formatDate(treatment.withdrawalEndDate))
          .replaceAll('{days}', daysRemaining.toString());
    } else {
      color = Colors.green;
      icon = Icons.check_circle;
      message = l10n.translate(AppStrings.withdrawalCompleted);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: AppConstants.iconSizeMedium),
                const SizedBox(width: AppConstants.spacingSmall),
                Text(
                  l10n.translate(AppStrings.withdrawalPeriod),
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              message,
              style: TextStyle(
                fontSize: AppConstants.fontSizeBody,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Consumer<AnimalProvider>(
          builder: (context, animalProvider, child) {
            final animal = animalProvider.getAnimalById(treatment.animalId);

            if (animal == null) {
              return Row(
                children: [
                  const Icon(Icons.pets, color: Colors.grey),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Text(
                    l10n.translate(AppStrings.animalNotFound),
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate(AppStrings.animal),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: AppConstants.spacingMediumLarge),
                Row(
                  children: [
                    Icon(
                      animal.sex == AnimalSex.male ? Icons.male : Icons.female,
                      color: animal.sex == AnimalSex.male
                          ? Colors.blue
                          : Colors.pink,
                      size: AppConstants.iconSizeMedium,
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            animal.displayName,
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${animal.sex == AnimalSex.male ? l10n.translate(AppStrings.male) : l10n.translate(AppStrings.female)} • ${animal.ageInMonths} ${l10n.translate(AppStrings.months)}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSubtitle,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasNotes = treatment.notes != null && treatment.notes!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate(AppStrings.notes),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: AppConstants.iconSizeRegular),
                  onPressed: () => _showEditNotesDialog(context),
                  tooltip: l10n.translate(AppStrings.editNotes),
                ),
              ],
            ),
            const Divider(height: AppConstants.spacingMediumLarge),
            Text(
              hasNotes
                  ? treatment.notes!
                  : l10n.translate(AppStrings.noNotes),
              style: TextStyle(
                fontSize: AppConstants.fontSizeBody,
                color: hasNotes ? Colors.black87 : Colors.grey,
                fontStyle: hasNotes ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: AppConstants.iconSizeXSmall, color: Colors.grey[600]),
        const SizedBox(width: AppConstants.spacingTiny),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: AppConstants.fontSizeBody,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeBody,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditNotesDialog(BuildContext context) {
    final notesController = TextEditingController(text: treatment.notes ?? '');

    showDialog(
      context: context,
      builder: (context) => _EditNotesDialog(
        treatment: treatment,
        notesController: notesController,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.deleteTreatment)),
        content: Text(l10n.translate(AppStrings.deleteTreatmentConfirm)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await context
                    .read<TreatmentProvider>()
                    .removeTreatment(treatment.id);

                if (context.mounted) {
                  Navigator.pop(context); // Fermer le dialog
                  Navigator.pop(context); // Retourner à l'écran précédent
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(l10n.translate(AppStrings.treatmentDeleted)),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n
                          .translate(AppStrings.errorOccurred)
                          .replaceAll('{error}', e.toString())),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.translate(AppStrings.delete)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// ==================== EDIT NOTES DIALOG ====================

class _EditNotesDialog extends StatefulWidget {
  final Treatment treatment;
  final TextEditingController notesController;

  const _EditNotesDialog({
    required this.treatment,
    required this.notesController,
  });

  @override
  State<_EditNotesDialog> createState() => _EditNotesDialogState();
}

class _EditNotesDialogState extends State<_EditNotesDialog> {
  bool _isSaving = false;

  @override
  void dispose() {
    widget.notesController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes() async {
    setState(() => _isSaving = true);

    try {
      final treatmentProvider = context.read<TreatmentProvider>();
      final updatedTreatment = widget.treatment.copyWith(
        notes: widget.notesController.text.trim().isEmpty
            ? null
            : widget.notesController.text.trim(),
      );

      await treatmentProvider.updateTreatment(updatedTreatment);

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
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.translate(AppStrings.editNotes)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.notesController,
              maxLength: AppConstants.maxNotesLength,
              maxLines: 8,
              decoration: InputDecoration(
                hintText:
                    l10n.translate(AppStrings.notesPlaceholder),
                border: const OutlineInputBorder(),
                helperText:
                    l10n.translate(AppStrings.notesMaxLength),
              ),
              enabled: !_isSaving,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(l10n.translate(AppStrings.cancel)),
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
                    Text(l10n.translate(AppStrings.save)),
                  ],
                ),
        ),
      ],
    );
  }
}
