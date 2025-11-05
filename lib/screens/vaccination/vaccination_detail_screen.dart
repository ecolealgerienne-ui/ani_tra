// lib/screens/vaccination/vaccination_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vaccination_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/vaccination.dart';
//import '../../models/animal.dart';
import '../../models/vaccination_protocol.dart';

class VaccinationDetailScreen extends StatelessWidget {
  final Vaccination vaccination;

  const VaccinationDetailScreen({
    super.key,
    required this.vaccination,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Vaccination'),
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
            _buildHeaderCard(),
            const SizedBox(height: 8),
            _buildInfoCard(),
            const SizedBox(height: 8),
            _buildAnimalCard(context),
            const SizedBox(height: 8),
            if (vaccination.nextDueDate != null) _buildReminderCard(),
            const SizedBox(height: 8),
            if (vaccination.notes != null && vaccination.notes!.isNotEmpty)
              _buildNotesCard(),
            if (vaccination.protocolId != null) ...[
              const SizedBox(height: 8),
              _buildProtocolCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
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
                    color: _getTypeColor(vaccination.type).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    vaccination.type.label,
                    style: TextStyle(
                      fontSize: 12,
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
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.group, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${vaccination.animalCount} animaux',
                          style: const TextStyle(
                            fontSize: 12,
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.medical_services, size: 18, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  vaccination.disease,
                  style: const TextStyle(
                    fontSize: 16,
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

  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Date vaccination',
              _formatDate(vaccination.vaccinationDate),
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.science,
              'Dose',
              vaccination.dose,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.local_hospital,
              'Voie d\'administration',
              vaccination.administrationRoute,
            ),
            if (vaccination.batchNumber != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.qr_code,
                'N° de lot',
                vaccination.batchNumber!,
              ),
            ],
            if (vaccination.expiryDate != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.event_busy,
                'Date d\'expiration',
                _formatDate(vaccination.expiryDate!),
              ),
            ],
            if (vaccination.veterinarianName != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.person,
                'Vétérinaire',
                vaccination.veterinarianName!,
              ),
            ],
            if (vaccination.withdrawalPeriodDays > 0) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.access_time,
                'Délai d\'attente',
                '${vaccination.withdrawalPeriodDays} jours',
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
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'Encore ${vaccination.daysRemainingInWithdrawal} jours de délai',
                          style: const TextStyle(
                            fontSize: 12,
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
                const Text(
                  'Animaux concernés',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (vaccination.isGroupVaccination)
                  Text(
                    '${vaccination.animalCount} animaux',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (vaccination.isGroupVaccination) ...[
              ...vaccination.animalIds.take(5).map((animalId) {
                final animal = animalProvider.getAnimalById(animalId);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.pets, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        animal?.displayName ?? 'Animal inconnu',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (vaccination.animalCount > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '... et ${vaccination.animalCount - 5} autres',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ] else ...[
              Builder(
                builder: (context) {
                  final animal = animalProvider.getAnimalById(
                    vaccination.animalId!,
                  );
                  return Row(
                    children: [
                      const Icon(Icons.pets, size: 20, color: Colors.green),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            animal?.displayName ?? 'Animal inconnu',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (animal?.officialNumber != null)
                            Text(
                              animal!.officialNumber!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard() {
    final days = vaccination.daysUntilReminder!;
    final isOverdue = days < 0;
    final color =
        isOverdue ? Colors.red : (days <= 7 ? Colors.orange : Colors.blue);

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
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Rappel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOverdue
                        ? 'En retard de ${-days} jours'
                        : days == 0
                            ? 'Aujourd\'hui'
                            : 'Dans $days jours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Prochain rappel: ${_formatDate(vaccination.nextDueDate!)}',
                    style: TextStyle(
                      fontSize: 14,
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

  Widget _buildNotesCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.note, size: 20, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              vaccination.notes!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard() {
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
            const Row(
              children: [
                Icon(Icons.assignment, size: 20, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Protocole',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.label,
              'Nom',
              protocol.name,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.description,
              'Description',
              protocol.description,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.repeat,
              'Fréquence rappel',
              '${protocol.reminderIntervalDays} jours',
            ),
            if (protocol.recommendedPeriod != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.event,
                'Période recommandée',
                protocol.recommendedPeriod!,
              ),
            ],
            if (protocol.notes != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                Icons.info_outline,
                'Notes protocole',
                protocol.notes!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la vaccination'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette vaccination ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<VaccinationProvider>().removeVaccination(
                    vaccination.id,
                  );
              Navigator.pop(context); // Fermer dialog
              Navigator.pop(context); // Retour à la liste
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vaccination supprimée'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
