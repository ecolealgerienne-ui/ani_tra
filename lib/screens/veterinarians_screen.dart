// lib/screens/veterinarians_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/veterinarian_provider.dart';
import '../models/veterinarian.dart';
import 'package:url_launcher/url_launcher.dart';

class VeterinariansScreen extends StatefulWidget {
  const VeterinariansScreen({super.key});

  @override
  State<VeterinariansScreen> createState() => _VeterinariansScreenState();
}

class _VeterinariansScreenState extends State<VeterinariansScreen> {
  String _searchQuery = '';
  String _filterBy = 'all'; // all, available, preferred, emergency
  String _sortBy = 'name'; // name, rating, interventions

  @override
  Widget build(BuildContext context) {
    final vetProvider = context.watch<VeterinarianProvider>();

    // Filtrer les vétérinaires
    List<Veterinarian> filteredVets = vetProvider.activeVeterinarians;

    if (_searchQuery.isNotEmpty) {
      filteredVets = vetProvider.searchVeterinarians(_searchQuery);
    }

    // Appliquer les filtres
    switch (_filterBy) {
      case 'available':
        filteredVets = filteredVets.where((v) => v.isAvailable).toList();
        break;
      case 'preferred':
        filteredVets = filteredVets.where((v) => v.isPreferred).toList();
        break;
      case 'emergency':
        filteredVets = filteredVets
            .where((v) => v.emergencyService && v.isAvailable)
            .toList();
        break;
    }

    // Trier
    filteredVets.sort((a, b) {
      switch (_sortBy) {
        case 'rating':
          return b.rating.compareTo(a.rating);
        case 'interventions':
          return b.totalInterventions.compareTo(a.totalInterventions);
        case 'name':
        default:
          return a.fullName.compareTo(b.fullName);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vétérinaires'),
        actions: [
          // Stats rapides
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => _showStatsDialog(context, vetProvider),
          ),
          // Menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sort') {
                _showSortDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort),
                    SizedBox(width: 8),
                    Text('Trier'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un vétérinaire...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Filtres
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'Tous',
                  count: vetProvider.activeVeterinarians.length,
                  isSelected: _filterBy == 'all',
                  onTap: () => setState(() => _filterBy = 'all'),
                ),
                _FilterChip(
                  label: 'Disponibles',
                  count: vetProvider.availableVeterinarians.length,
                  isSelected: _filterBy == 'available',
                  onTap: () => setState(() => _filterBy = 'available'),
                  color: Colors.green,
                ),
                _FilterChip(
                  label: 'Préférés',
                  count: vetProvider.preferredVeterinarians.length,
                  isSelected: _filterBy == 'preferred',
                  onTap: () => setState(() => _filterBy = 'preferred'),
                  color: Colors.orange,
                ),
                _FilterChip(
                  label: 'Urgences',
                  count: vetProvider.emergencyVeterinarians.length,
                  isSelected: _filterBy == 'emergency',
                  onTap: () => setState(() => _filterBy = 'emergency'),
                  color: Colors.red,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Liste des vétérinaires
          Expanded(
            child: filteredVets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Aucun vétérinaire trouvé'
                              : 'Aucun vétérinaire',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredVets.length,
                    itemBuilder: (context, index) {
                      final vet = filteredVets[index];
                      return _VeterinarianCard(veterinarian: vet);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add veterinarian screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ouvrir add_veterinarian_screen.dart'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trier par'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Nom'),
              value: 'name',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Note (décroissante)'),
              value: 'rating',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Interventions (décroissant)'),
              value: 'interventions',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStatsDialog(BuildContext context, VeterinarianProvider provider) {
    final stats = provider.stats;
    final mostActive = provider.getMostActiveVeterinarian();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistiques'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatRow(
              icon: Icons.person,
              label: 'Total vétérinaires',
              value: '${stats['total']}',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.check_circle,
              label: 'Disponibles',
              value: '${stats['available']}',
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.star,
              label: 'Préférés',
              value: '${stats['preferred']}',
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.emergency,
              label: 'Service d\'urgence',
              value: '${stats['emergency']}',
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.medical_services,
              label: 'Total interventions',
              value: '${stats['totalInterventions']}',
              color: Colors.purple,
            ),
            if (mostActive != null) ...[
              const Divider(height: 24),
              Text(
                'Plus actif:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(mostActive.fullName),
                subtitle:
                    Text('${mostActive.totalInterventions} interventions'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

// Widgets personnalisés
class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text('$label ($count)'),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: color?.withOpacity(0.2),
        checkmarkColor: color,
      ),
    );
  }
}

class _VeterinarianCard extends StatelessWidget {
  final Veterinarian veterinarian;

  const _VeterinarianCard({required this.veterinarian});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to detail screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ouvrir détails: ${veterinarian.fullName}'),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      '${veterinarian.firstName[0]}${veterinarian.lastName[0]}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Nom et info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                veterinarian.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Badges
                            if (veterinarian.isPreferred)
                              const Icon(Icons.star,
                                  color: Colors.orange, size: 20),
                            if (veterinarian.emergencyService)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.emergency,
                                    color: Colors.red, size: 20),
                              ),
                            if (!veterinarian.isAvailable)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.schedule,
                                    color: Colors.grey, size: 20),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (veterinarian.clinic != null)
                          Text(
                            veterinarian.clinic!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        const SizedBox(height: 4),
                        // Note
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < veterinarian.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 14,
                                color: Colors.orange,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              '${veterinarian.totalInterventions} interventions',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Spécialités
              if (veterinarian.specialties.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: veterinarian.specialties.take(3).map((specialty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        specialty,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12),
              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _makePhoneCall(context, veterinarian.phone),
                      icon: const Icon(Icons.phone, size: 16),
                      label: const Text('Appeler'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  if (veterinarian.hasEmail) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _sendEmail(context, veterinarian.email!),
                        icon: const Icon(Icons.email, size: 16),
                        label: const Text('Email'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      veterinarian.isPreferred ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      context
                          .read<VeterinarianProvider>()
                          .togglePreferred(veterinarian.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            veterinarian.isPreferred
                                ? 'Retiré des préférés'
                                : 'Ajouté aux préférés',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Statut disponibilité
              if (!veterinarian.isAvailable) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          veterinarian.notes ?? 'Actuellement indisponible',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                          ),
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
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
