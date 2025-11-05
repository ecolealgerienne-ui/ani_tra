// lib/screens/vaccination/vaccination_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vaccination_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/vaccination.dart';
import '../../models/animal.dart';
import '0_vaccination_detail_screen.dart';
import '0_add_vaccination_screen.dart';

class VaccinationListScreen extends StatefulWidget {
  const VaccinationListScreen({super.key});

  @override
  State<VaccinationListScreen> createState() => _VaccinationListScreenState();
}

class _VaccinationListScreenState extends State<VaccinationListScreen> {
  final _searchController = TextEditingController();

  String _filterStatus = 'all'; // all, overdue, upcoming, recent
  String _sortBy = 'date_desc'; // date_desc, date_asc, disease, type

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Vaccination> _getFilteredVaccinations(List<Vaccination> vaccinations) {
    var filtered = vaccinations.toList(); // Copie modifiable

    // Filtre recherche
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((v) =>
              v.vaccineName.toLowerCase().contains(query) ||
              v.disease.toLowerCase().contains(query))
          .toList();
    }

    // Filtre statut
    switch (_filterStatus) {
      case 'overdue':
        filtered = filtered
            .where((v) => v.nextDueDate != null && v.daysUntilReminder! < 0)
            .toList();
        break;
      case 'upcoming':
        filtered = filtered
            .where((v) =>
                v.nextDueDate != null &&
                v.isReminderDue &&
                v.daysUntilReminder! >= 0)
            .toList();
        break;
      case 'recent':
        final cutoff = DateTime.now().subtract(const Duration(days: 30));
        filtered =
            filtered.where((v) => v.vaccinationDate.isAfter(cutoff)).toList();
        break;
    }

    // Tri
    switch (_sortBy) {
      case 'date_desc':
        filtered.sort((a, b) => b.vaccinationDate.compareTo(a.vaccinationDate));
        break;
      case 'date_asc':
        filtered.sort((a, b) => a.vaccinationDate.compareTo(b.vaccinationDate));
        break;
      case 'disease':
        filtered.sort((a, b) => a.disease.compareTo(b.disease));
        break;
      case 'type':
        filtered.sort((a, b) => a.type.index.compareTo(b.type.index));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccinations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildVaccinationList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVaccinationScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher vaccin, maladie...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() => _searchController.clear());
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Tous'),
            selected: _filterStatus == 'all',
            onSelected: (_) => setState(() => _filterStatus = 'all'),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('En retard'),
            selected: _filterStatus == 'overdue',
            onSelected: (_) => setState(() => _filterStatus = 'overdue'),
            avatar: const Icon(Icons.warning, size: 18),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('À venir'),
            selected: _filterStatus == 'upcoming',
            onSelected: (_) => setState(() => _filterStatus = 'upcoming'),
            avatar: const Icon(Icons.notifications, size: 18),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Récentes'),
            selected: _filterStatus == 'recent',
            onSelected: (_) => setState(() => _filterStatus = 'recent'),
            avatar: const Icon(Icons.history, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationList() {
    return Consumer<VaccinationProvider>(
      builder: (context, provider, _) {
        final vaccinations = _getFilteredVaccinations(provider.vaccinations);

        if (vaccinations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.vaccines_outlined,
                    size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Aucune vaccination',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vaccinations.length,
          itemBuilder: (context, index) {
            return _buildVaccinationCard(vaccinations[index]);
          },
        );
      },
    );
  }

  Widget _buildVaccinationCard(Vaccination vaccination) {
    final animalProvider = context.read<AnimalProvider>();

    String animalInfo;
    if (vaccination.isGroupVaccination) {
      animalInfo = '${vaccination.animalCount} animaux';
    } else {
      final animal = animalProvider.getAnimalById(vaccination.animalId!);
      animalInfo = animal?.displayName ?? 'Animal inconnu';
    }

    Color? reminderColor;
    IconData? reminderIcon;
    String? reminderText;

    if (vaccination.nextDueDate != null) {
      final days = vaccination.daysUntilReminder!;
      if (days < 0) {
        reminderColor = Colors.red;
        reminderIcon = Icons.error;
        reminderText = 'Retard ${-days}j';
      } else if (days <= 7) {
        reminderColor = Colors.orange;
        reminderIcon = Icons.warning;
        reminderText = 'Dans $days jours';
      } else if (days <= 30) {
        reminderColor = Colors.blue;
        reminderIcon = Icons.info;
        reminderText = 'Dans $days jours';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VaccinationDetailScreen(
                vaccination: vaccination,
              ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(vaccination.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vaccination.type.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(vaccination.type),
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (vaccination.isGroupVaccination)
                    const Icon(Icons.group, size: 16, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                vaccination.vaccineName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                vaccination.disease,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(vaccination.vaccinationDate),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.pets, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    animalInfo,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (reminderText != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: reminderColor?.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(reminderIcon, size: 14, color: reminderColor),
                      const SizedBox(width: 4),
                      Text(
                        'Rappel: $reminderText',
                        style: TextStyle(
                          fontSize: 12,
                          color: reminderColor,
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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trier par',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<String>(
                    title: const Text('Date (plus récent)'),
                    value: 'date_desc',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setState(() => _sortBy = value!);
                      setModalState(() => _sortBy = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Date (plus ancien)'),
                    value: 'date_asc',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setState(() => _sortBy = value!);
                      setModalState(() => _sortBy = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Maladie'),
                    value: 'disease',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setState(() => _sortBy = value!);
                      setModalState(() => _sortBy = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Type'),
                    value: 'type',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setState(() => _sortBy = value!);
                      setModalState(() => _sortBy = value!);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
