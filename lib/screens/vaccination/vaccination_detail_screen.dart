// lib/screens/vaccination/vaccination_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vaccination_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/vaccination.dart';
import '../../models/vaccination_protocol.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

class VaccinationDetailScreen extends StatelessWidget {
  final Vaccination vaccination;

  const VaccinationDetailScreen({
    super.key,
    required this.vaccination,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.vaccinationDetail)),
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
            const SizedBox(height: 8),
            _buildInfoCard(context),
            const SizedBox(height: 8),
            _buildAnimalCard(context),
            const SizedBox(height: 8),
            if (vaccination.nextDueDate != null) _buildReminderCard(context),
            const SizedBox(height: 8),
            if (vaccination.notes != null && vaccination.notes!.isNotEmpty)
              _buildNotesCard(context),
            if (vaccination.protocolId != null) ...[
              const SizedBox(height: 8),
              _buildProtocolCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(vaccination.type)
                        .withValues(alpha: AppConstants.opacityMedium),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                  child: Text(
                    vaccination.type.label,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(vaccination.type),
                    ),
                  ),
                ),
                const Spacer(),
                if (vaccination.isGroupVaccination)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue
                          .withValues(alpha: AppConstants.opacityMedium),
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadiusSmall),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.group,
                            size: AppConstants.iconSizeTiny,
                            color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${vaccination.animalCount} ${l10n.translate(AppStrings.animalsLowercase)}',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              vaccination.vaccineName,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeLargeTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.medical_services,
                    size: AppConstants.iconSizeSmall, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  vaccination.disease,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSectionTitle,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate(AppStrings.information),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSectionTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              Icons.calendar_today,
              l10n.translate(AppStrings.vaccinationDate),
              _formatDate(vaccination.vaccinationDate),
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              Icons.science,
              l10n.translate(AppStrings.doseLabel),
              vaccination.dose,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              Icons.local_hospital,
              l10n.translate(AppStrings.administrationRoute),
              vaccination.administrationRoute,
            ),
            if (vaccination.batchNumber != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                context,
                Icons.qr_code,
                l10n.translate(AppStrings.lotNumber),
                vaccination.batchNumber!,
              ),
            ],
            if (vaccination.expiryDate != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                context,
                Icons.event_busy,
                l10n.translate(AppStrings.expirationDate),
                _formatDate(vaccination.expiryDate!),
              ),
            ],
            if (vaccination.veterinarianName != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                context,
                Icons.person,
                l10n.translate(AppStrings.veterinarianLabel),
                vaccination.veterinarianName!,
              ),
            ],
            if (vaccination.withdrawalPeriodDays > 0) ...[
              const Divider(height: 24),
              _buildInfoRow(
                context,
                Icons.access_time,
                l10n.translate(AppStrings.withdrawalPeriodLabel),
                '${vaccination.withdrawalPeriodDays} ${l10n.translate(AppStrings.days)}',
                valueColor: vaccination.isInWithdrawalPeriod
                    ? Colors.red
                    : Colors.grey[700],
              ),
              if (vaccination.isInWithdrawalPeriod)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red
                          .withValues(alpha: AppConstants.opacityLight),
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadiusSmall),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning,
                            size: AppConstants.iconSizeTiny, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          l10n.translate(AppStrings.daysRemaining).replaceAll(
                              '{days}',
                              vaccination.daysRemainingInWithdrawal.toString()),
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final animalProvider = context.read<AnimalProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.pets,
                  size: AppConstants.iconSizeRegular,
                  color: Colors.teal,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.translate(AppStrings.animal),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSectionTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (vaccination.isGroupVaccination)
              Text(
                l10n
                    .translate(AppStrings.groupVaccination)
                    .replaceAll('{count}', vaccination.animalCount.toString()),
                style: TextStyle(
                  fontSize: AppConstants.fontSizeBody,
                  color: Colors.grey[700],
                ),
              )
            else if (vaccination.animalId != null &&
                vaccination.animalId!.isNotEmpty)
              FutureBuilder(
                future: Future.value(
                    animalProvider.getAnimalById(vaccination.animalId!)),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      l10n
                          .translate(AppStrings.animalPrefix)
                          .replaceAll('{id}', vaccination.animalId!),
                      style: TextStyle(
                          fontSize: AppConstants.fontSizeBody,
                          color: Colors.grey[700]),
                    );
                  }
                  final animal = snapshot.data;
                  return Text(
                    animal?.displayName ?? l10n.translate(AppStrings.animal),
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              )
            else
              Text(
                l10n.translate(AppStrings.unknownAnimal),
                style: TextStyle(
                    fontSize: AppConstants.fontSizeBody,
                    color: Colors.grey[700]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = vaccination.nextDueDate?.difference(DateTime.now()).inDays;
    final isOverdue = days! < 0;
    final color = isOverdue ? Colors.red : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOverdue ? Icons.error : Icons.notifications,
                  color: color,
                  size: AppConstants.iconSizeRegular,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.translate(AppStrings.reminder),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSectionTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: AppConstants.opacityLight),
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOverdue
                        ? l10n
                            .translate(AppStrings.lateByDays)
                            .replaceAll('{days}', (-days).toString())
                        : days == 0
                            ? l10n.translate(AppStrings.today)
                            : l10n
                                .translate(AppStrings.inDays)
                                .replaceAll('{days}', days.toString()),
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSectionTitle,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.translate(AppStrings.nextReminder).replaceAll(
                        '{date}', _formatDate(vaccination.nextDueDate!)),
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.note,
                    size: AppConstants.iconSizeRegular, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  l10n.translate(AppStrings.notesLabel),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSectionTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              vaccination.notes!,
              style: TextStyle(
                fontSize: AppConstants.fontSizeBody,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final protocol = VaccinationProtocols.getProtocolById(
      vaccination.protocolId!,
    );

    if (protocol == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment,
                    size: AppConstants.iconSizeRegular, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  l10n.translate(AppStrings.protocolLabel),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSectionTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              Icons.label,
              l10n.translate(AppStrings.name),
              protocol.name,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              Icons.description,
              l10n.translate(AppStrings.description),
              protocol.description,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              Icons.repeat,
              l10n.translate(AppStrings.reminderFrequency),
              '${protocol.reminderIntervalDays} ${l10n.translate(AppStrings.days)}',
            ),
            if (protocol.recommendedPeriod != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                context,
                Icons.event,
                l10n.translate(AppStrings.recommendedPeriod),
                protocol.recommendedPeriod!,
              ),
            ],
            if (protocol.notes != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                context,
                Icons.info_outline,
                l10n.translate(AppStrings.protocolNotes),
                protocol.notes!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppConstants.iconSizeSmall, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLabel,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(VaccinationType type) {
    switch (type) {
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

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.deleteVaccination)),
        content: Text(
          l10n.translate(AppStrings.deleteVaccinationConfirm),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
          TextButton(
            onPressed: () {
              context.read<VaccinationProvider>().removeVaccination(
                    vaccination.id,
                  );
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate(AppStrings.vaccinationDeleted)),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.translate(AppStrings.delete)),
          ),
        ],
      ),
    );
  }
}
