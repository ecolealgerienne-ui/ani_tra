// lib/screens/animal_finder_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../models/animal.dart';
import '../../models/scan_result.dart';
import '../../providers/animal_provider.dart';
import '../../providers/rfid_scanner_provider.dart';
import 'universal_scanner_screen.dart';

enum AnimalFinderMode {
  single,
  multiple,
}

class AnimalFinderScreen extends StatefulWidget {
  final AnimalFinderMode mode;
  final List<Animal> initialSelection;
  final String title;
  final List<AnimalStatus>? allowedStatuses;

  const AnimalFinderScreen({
    super.key,
    this.mode = AnimalFinderMode.multiple,
    this.initialSelection = const [],
    this.title = 'Identifier animaux',
    this.allowedStatuses,
  });

  @override
  State<AnimalFinderScreen> createState() => _AnimalFinderScreenState();
}

class _AnimalFinderScreenState extends State<AnimalFinderScreen> {
  final _searchController = TextEditingController();
  List<Animal> _selectedAnimals = [];
  String _searchQuery = '';
  StreamSubscription<String>? _rfidSubscription;

  @override
  void initState() {
    super.initState();
    _selectedAnimals = List.from(widget.initialSelection);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _rfidSubscription?.cancel();
    super.dispose();
  }

  List<Animal> _getAvailableAnimals() {
    final animalProvider = context.read<AnimalProvider>();
    List<Animal> animals = animalProvider.animals;

    if (widget.allowedStatuses != null) {
      animals = animals
          .where((a) => widget.allowedStatuses!.contains(a.status))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      animals = animals.where((animal) {
        return (animal.currentEid?.toLowerCase().contains(query) ?? false) ||
            (animal.officialNumber?.toLowerCase().contains(query) ?? false) ||
            (animal.visualId?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return animals;
  }

  void _onAnimalFound(Animal animal) {
    if (_selectedAnimals.any((a) => a.id == animal.id)) {
      _showDuplicateFeedback(animal);
      return;
    }

    setState(() {
      if (widget.mode == AnimalFinderMode.single) {
        Navigator.pop(context, animal);
      } else {
        _selectedAnimals.add(animal);
      }
    });

    if (widget.mode == AnimalFinderMode.multiple) {
      _showSuccessFeedback(animal);
    }
  }

  void _removeAnimal(Animal animal) {
    setState(() {
      _selectedAnimals.removeWhere((a) => a.id == animal.id);
    });
  }

  void _showDuplicateFeedback(Animal animal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('⚠️ ${animal.displayName} déjà scanné'),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSuccessFeedback(Animal animal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('✅ ${animal.displayName} ajouté'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _startRFIDScan() async {
    final rfidProvider = context.read<RFIDScannerProvider>();
    final animalProvider = context.read<AnimalProvider>();

    if (rfidProvider.isScanning) {
      rfidProvider.stopScanning();
      _rfidSubscription?.cancel();
      return;
    }

    final availableAnimals = _getAvailableAnimals();

    if (availableAnimals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Aucun animal disponible'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    rfidProvider.startScanning(availableAnimals);

    _rfidSubscription = rfidProvider.eidStream?.listen((eid) {
      final animal = animalProvider.animals.firstWhere(
        (a) => a.currentEid == eid,
        orElse: () => animalProvider.animals.first,
      );
      if (animal.currentEid != null) {
        _onAnimalFound(animal);
      }
    });
  }

  Future<void> _startCameraScan() async {
    final result = await Navigator.push<ScanResult>(
      context,
      MaterialPageRoute(
        builder: (context) => const UniversalScannerScreen(mode: 'register'),
      ),
    );

    if (result != null && mounted) {
      final animalProvider = context.read<AnimalProvider>();
      final animal = result.findMatchingAnimal(animalProvider.animals);

      if (animal != null) {
        _onAnimalFound(animal);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Animal non trouvé'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _complete() {
    Navigator.pop(context, _selectedAnimals);
  }

  @override
  Widget build(BuildContext context) {
    final rfidProvider = context.watch<RFIDScannerProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_selectedAnimals.isNotEmpty &&
              widget.mode == AnimalFinderMode.multiple)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_selectedAnimals.length}',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher EID, N° officiel, ID visuel...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Indicateur RFID actif
          if (rfidProvider.isScanning)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blue.shade100,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '📡 Lecteur RFID actif - Scannez les animaux',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Zone centrale
          Expanded(
            child: Column(
              children: [
                // Animaux sélectionnés (si mode multiple)
                if (_selectedAnimals.isNotEmpty &&
                    widget.mode == AnimalFinderMode.multiple)
                  _buildSelectedAnimalsSection(),

                // Résultats de recherche ou état vide
                Expanded(
                  child: _searchQuery.isEmpty && _selectedAnimals.isEmpty
                      ? _buildEmptyState()
                      : _buildSearchResults(),
                ),
              ],
            ),
          ),

          // Boutons scan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _startRFIDScan,
                    icon: Icon(
                      rfidProvider.isScanning
                          ? Icons.stop
                          : Icons.bluetooth_searching,
                    ),
                    label: Text(
                      rfidProvider.isScanning ? 'ARRÊTER' : 'SCAN RFID',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          rfidProvider.isScanning ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _startCameraScan,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('CAMÉRA'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedAnimals.isNotEmpty &&
              widget.mode == AnimalFinderMode.multiple
          ? FloatingActionButton.extended(
              onPressed: _complete,
              icon: const Icon(Icons.check),
              label: Text('TERMINÉ (${_selectedAnimals.length})'),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'Scanner ou rechercher\ndes animaux',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAnimalsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Sélectionnés (${_selectedAnimals.length})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedAnimals.map((animal) {
              return Chip(
                avatar: const Icon(Icons.pets, size: 16),
                label: Text(
                  animal.displayName,
                  style: const TextStyle(fontSize: 12),
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeAnimal(animal),
                backgroundColor: Colors.white,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final availableAnimals = _getAvailableAnimals();

    if (availableAnimals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun animal trouvé',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Essayez avec un autre identifiant',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableAnimals.length,
      itemBuilder: (context, index) {
        final animal = availableAnimals[index];
        final isSelected = _selectedAnimals.any((a) => a.id == animal.id);

        return Card(
          color: isSelected ? Colors.green.shade50 : null,
          child: ListTile(
            leading: Icon(
              Icons.pets,
              color: isSelected ? Colors.green : null,
            ),
            title: Text(
              animal.displayName,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
            subtitle: Text(
              [
                if (animal.currentEid != null) 'EID: ${animal.currentEid}',
                if (animal.officialNumber != null)
                  'N°: ${animal.officialNumber}',
                if (animal.visualId != null) 'ID: ${animal.visualId}',
              ].join(' • '),
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: Colors.green.shade700)
                : const Icon(Icons.add_circle_outline),
            onTap: () => _onAnimalFound(animal),
          ),
        );
      },
    );
  }

  Widget _buildAnimalTable() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Animaux sélectionnés',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('EID')),
                  DataColumn(label: Text('ID visuel')),
                  DataColumn(label: Text('')),
                ],
                rows: _selectedAnimals.map((animal) {
                  return DataRow(
                    cells: [
                      DataCell(
                          Text(animal.currentEid ?? animal.visualId ?? '-')),
                      DataCell(Text(animal.visualId ?? '-')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => _removeAnimal(animal),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
