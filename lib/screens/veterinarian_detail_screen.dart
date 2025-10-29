// lib/screens/veterinarian_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/veterinarian_provider.dart';
import '../models/veterinarian.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VeterinarianDetailScreen extends StatefulWidget {
  final String veterinarianId;

  const VeterinarianDetailScreen({
    super.key,
    required this.veterinarianId,
  });

  @override
  State<VeterinarianDetailScreen> createState() =>
      _VeterinarianDetailScreenState();
}

class _VeterinarianDetailScreenState extends State<VeterinarianDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vetProvider = context.watch<VeterinarianProvider>();
    final vet = vetProvider.getVeterinarianById(widget.veterinarianId);

    if (vet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vétérinaire non trouvé')),
        body: const Center(
          child: Text('Le vétérinaire demandé n\'existe pas'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vet.fullName),
        actions: [
          IconButton(
            icon: Icon(
              vet.isPreferred ? Icons.star : Icons.star_border,
              color: vet.isPreferred ? Colors.orange : null,
            ),
            onPressed: () {
              vetProvider.togglePreferred(vet.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ouvrir écran d\'édition'),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context, vet);
              } else if (value == 'toggle_available') {
                vetProvider.toggleAvailability(vet.id);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_available',
                child: Row(
                  children: [
                    Icon(
                      vet.isAvailable ? Icons.block : Icons.check_circle,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      vet.isAvailable
                          ? 'Marquer indisponible'
                          : 'Marquer disponible',
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Infos'),
            Tab(icon: Icon(Icons.medical_services), text: 'Interventions'),
            Tab(icon: Icon(Icons.contact_phone), text: 'Contact'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _InfoTab(veterinarian: vet),
          _InterventionsTab(veterinarian: vet),
          _ContactTab(veterinarian: vet),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _makePhoneCall(context, vet.phone),
        icon: const Icon(Icons.phone),
        label: const Text('Appeler'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Veterinarian vet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le vétérinaire'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ${vet.fullName} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<VeterinarianProvider>().deleteVeterinarian(vet.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vétérinaire supprimé'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de passer l\'appel')),
        );
      }
    }
  }
}

// ============================================================================
// TAB 1: INFORMATIONS
// ============================================================================
class _InfoTab extends StatelessWidget {
  final Veterinarian veterinarian;

  const _InfoTab({required this.veterinarian});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // En-tête avec avatar et note
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  '${veterinarian.firstName[0]}${veterinarian.lastName[0]}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                veterinarian.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    index < veterinarian.rating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.orange,
                    size: 24,
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Badges
              Wrap(
                spacing: 8,
                children: [
                  if (veterinarian.isPreferred)
                    Chip(
                      avatar: const Icon(Icons.star, size: 16),
                      label: const Text('Préféré'),
                      backgroundColor: Colors.orange.shade100,
                    ),
                  if (veterinarian.emergencyService)
                    Chip(
                      avatar: const Icon(Icons.emergency, size: 16),
                      label: const Text('Urgences'),
                      backgroundColor: Colors.red.shade100,
                    ),
                  Chip(
                    avatar: Icon(
                      veterinarian.isAvailable
                          ? Icons.check_circle
                          : Icons.schedule,
                      size: 16,
                    ),
                    label: Text(
                      veterinarian.isAvailable ? 'Disponible' : 'Indisponible',
                    ),
                    backgroundColor: veterinarian.isAvailable
                        ? Colors.green.shade100
                        : Colors.grey.shade300,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Informations professionnelles
        _SectionTitle('Informations professionnelles'),
        _InfoCard(
          children: [
            _InfoRow('Numéro d\'ordre', veterinarian.licenseNumber),
            if (veterinarian.clinic != null)
              _InfoRow('Cabinet/Clinique', veterinarian.clinic!),
            _InfoRow('Spécialités', veterinarian.specialtiesFormatted),
          ],
        ),

        const SizedBox(height: 16),

        // Disponibilité
        _SectionTitle('Disponibilité'),
        _InfoCard(
          children: [
            _InfoRow(
              'Statut',
              veterinarian.isAvailable ? 'Disponible' : 'Indisponible',
              icon: veterinarian.isAvailable
                  ? Icons.check_circle
                  : Icons.schedule,
              iconColor: veterinarian.isAvailable ? Colors.green : Colors.grey,
            ),
            _InfoRow(
              'Service d\'urgence',
              veterinarian.emergencyService ? 'Oui' : 'Non',
              icon: veterinarian.emergencyService
                  ? Icons.emergency
                  : Icons.cancel,
              iconColor:
                  veterinarian.emergencyService ? Colors.red : Colors.grey,
            ),
            if (veterinarian.workingHours != null)
              _InfoRow('Horaires', veterinarian.workingHours!),
          ],
        ),

        const SizedBox(height: 16),

        // Tarifs
        _SectionTitle('Tarifs'),
        _InfoCard(
          children: [
            if (veterinarian.consultationFee != null)
              _InfoRow(
                'Consultation',
                '${veterinarian.consultationFee!.toStringAsFixed(2)} ${veterinarian.currency ?? 'EUR'}',
                icon: Icons.euro,
                iconColor: Colors.green,
              ),
            if (veterinarian.emergencyFee != null)
              _InfoRow(
                'Intervention urgence',
                '${veterinarian.emergencyFee!.toStringAsFixed(2)} ${veterinarian.currency ?? 'EUR'}',
                icon: Icons.emergency,
                iconColor: Colors.red,
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Statistiques
        _SectionTitle('Statistiques'),
        _InfoCard(
          children: [
            _InfoRow(
              'Total interventions',
              '${veterinarian.totalInterventions}',
              icon: Icons.medical_services,
              iconColor: Colors.purple,
            ),
            if (veterinarian.lastInterventionDate != null)
              _InfoRow(
                'Dernière intervention',
                DateFormat('dd/MM/yyyy')
                    .format(veterinarian.lastInterventionDate!),
                icon: Icons.calendar_today,
                iconColor: Colors.blue,
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Notes
        if (veterinarian.notes != null) ...[
          _SectionTitle('Notes'),
          _InfoCard(
            children: [
              Text(
                veterinarian.notes!,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),

        // Modifier la note
        _SectionTitle('Évaluation'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Votre note:'),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < veterinarian.rating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.orange,
                        size: 32,
                      ),
                      onPressed: () {
                        context
                            .read<VeterinarianProvider>()
                            .updateRating(veterinarian.id, index + 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Note: ${index + 1}/5'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 80),
      ],
    );
  }
}

// ============================================================================
// TAB 2: INTERVENTIONS
// ============================================================================
class _InterventionsTab extends StatelessWidget {
  final Veterinarian veterinarian;

  const _InterventionsTab({required this.veterinarian});

  @override
  Widget build(BuildContext context) {
    // Simuler un historique d'interventions
    final interventions = _getMockInterventions();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Statistiques
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistiques d\'intervention',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(
                      label: 'Total',
                      value: '${veterinarian.totalInterventions}',
                      icon: Icons.medical_services,
                      color: Colors.blue,
                    ),
                    _StatColumn(
                      label: 'Ce mois',
                      value: '8',
                      icon: Icons.calendar_today,
                      color: Colors.green,
                    ),
                    _StatColumn(
                      label: 'Urgences',
                      value: '3',
                      icon: Icons.emergency,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Historique des interventions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...interventions.map((intervention) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getInterventionColor(
                                    intervention['type'] as String)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getInterventionIcon(
                                intervention['type'] as String),
                            color: _getInterventionColor(
                                intervention['type'] as String),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                intervention['title'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy à HH:mm')
                                    .format(intervention['date'] as DateTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getInterventionColor(
                                    intervention['type'] as String)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            intervention['type'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _getInterventionColor(
                                  intervention['type'] as String),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.pets, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          intervention['animal'] as String,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    if (intervention['description'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        intervention['description'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                    if (intervention['cost'] != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.euro, size: 14, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            '${intervention['cost']} EUR',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            )),

        const SizedBox(height: 80),
      ],
    );
  }

  List<Map<String, dynamic>> _getMockInterventions() {
    return [
      {
        'title': 'Consultation générale',
        'type': 'Consultation',
        'animal': 'Vache #1234',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'description': 'Contrôle de routine, état général bon',
        'cost': 65.0,
      },
      {
        'title': 'Intervention d\'urgence',
        'type': 'Urgence',
        'animal': 'Brebis #5678',
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'description': 'Mise bas difficile, agneau sauvé',
        'cost': 120.0,
      },
      {
        'title': 'Vaccination',
        'type': 'Vaccination',
        'animal': 'Troupeau ovin',
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'description': 'Vaccination entérotoxémie - 45 animaux',
        'cost': 280.0,
      },
      {
        'title': 'Chirurgie',
        'type': 'Chirurgie',
        'animal': 'Vache #9012',
        'date': DateTime.now().subtract(const Duration(days: 22)),
        'description': 'Césarienne réussie',
        'cost': 450.0,
      },
    ];
  }

  Color _getInterventionColor(String type) {
    switch (type) {
      case 'Urgence':
        return Colors.red;
      case 'Chirurgie':
        return Colors.purple;
      case 'Vaccination':
        return Colors.blue;
      case 'Consultation':
      default:
        return Colors.green;
    }
  }

  IconData _getInterventionIcon(String type) {
    switch (type) {
      case 'Urgence':
        return Icons.emergency;
      case 'Chirurgie':
        return Icons.healing;
      case 'Vaccination':
        return Icons.vaccines;
      case 'Consultation':
      default:
        return Icons.medical_services;
    }
  }
}

// ============================================================================
// TAB 3: CONTACT
// ============================================================================
class _ContactTab extends StatelessWidget {
  final Veterinarian veterinarian;

  const _ContactTab({required this.veterinarian});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Coordonnées
        _SectionTitle('Coordonnées'),
        _ContactCard(
          icon: Icons.phone,
          label: 'Téléphone',
          value: veterinarian.phone,
          onTap: () => _makePhoneCall(context, veterinarian.phone),
          color: Colors.green,
        ),
        if (veterinarian.hasMobile)
          _ContactCard(
            icon: Icons.smartphone,
            label: 'Mobile',
            value: veterinarian.mobile!,
            onTap: () => _makePhoneCall(context, veterinarian.mobile!),
            color: Colors.blue,
          ),
        if (veterinarian.hasEmail)
          _ContactCard(
            icon: Icons.email,
            label: 'Email',
            value: veterinarian.email!,
            onTap: () => _sendEmail(context, veterinarian.email!),
            color: Colors.orange,
          ),

        const SizedBox(height: 16),

        // Adresse
        if (veterinarian.fullAddress != null) ...[
          _SectionTitle('Adresse'),
          _ContactCard(
            icon: Icons.location_on,
            label: 'Adresse',
            value: veterinarian.fullAddress!,
            onTap: () => _openMaps(context, veterinarian.fullAddress!),
            color: Colors.red,
          ),
        ],

        const SizedBox(height: 16),

        // Actions rapides
        _SectionTitle('Actions rapides'),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.phone, color: Colors.white),
                ),
                title: const Text('Appeler'),
                subtitle: Text(veterinarian.phone),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _makePhoneCall(context, veterinarian.phone),
              ),
              const Divider(height: 1),
              if (veterinarian.hasEmail)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.email, color: Colors.white),
                  ),
                  title: const Text('Envoyer un email'),
                  subtitle: Text(veterinarian.email!),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _sendEmail(context, veterinarian.email!),
                ),
              if (veterinarian.hasEmail) const Divider(height: 1),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.message, color: Colors.white),
                ),
                title: const Text('Envoyer un SMS'),
                subtitle: Text(veterinarian.phone),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _sendSMS(context, veterinarian.phone),
              ),
            ],
          ),
        ),

        const SizedBox(height: 80),
      ],
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de passer l\'appel')),
        );
      }
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Demande de consultation',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'envoyer l\'email')),
        );
      }
    }
  }

  Future<void> _sendSMS(BuildContext context, String phone) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'envoyer le SMS')),
        );
      }
    }
  }

  Future<void> _openMaps(BuildContext context, String address) async {
    final Uri mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir Maps')),
        );
      }
    }
  }
}

// ============================================================================
// WIDGETS COMMUNS
// ============================================================================
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const _InfoRow(
    this.label,
    this.value, {
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: iconColor ?? Colors.grey),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Color color;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(label),
        subtitle: Text(value),
        trailing: Icon(Icons.chevron_right, color: color),
        onTap: onTap,
      ),
    );
  }
}
