// lib/screens/animal_finder_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../models/animal.dart';
import '../../models/scan_result.dart';
import '../../providers/animal_provider.dart';
import '../../providers/rfid_scanner_provider.dart';
import 'universal_scanner_screen.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

enum AnimalFinderMode {
  single,
  multiple,
}

class AnimalFinderScreen extends StatefulWidget {
  final AnimalFinderMode mode;
  final List<Animal> initialSelection;
  final String title;
  final List<AnimalStatus>? allowedStatuses;
  final String? lotId;
  final List<String>? animalIdsInLot;

  const AnimalFinderScreen({
    super.key,
    this.mode = AnimalFinderMode.multiple,
    this.initialSelection = const [],
    this.title = '',
    this.allowedStatuses,
    this.lotId,
    this.animalIdsInLot,
  });

  @override
  State<AnimalFinderScreen> createState() => _AnimalFinderScreenState();
}

class _AnimalFinderScreenState extends State<AnimalFinderScreen> {
  final _searchController = TextEditingController();
  List<Animal> _selectedAnimals = [];
  String _searchQuery = '';
  StreamSubscription<String>? _rfidSubscription;
  RFIDScannerProvider? _rfidProvider;

  @override
  void initState() {
    super.initState();
    _selectedAnimals = List.from(widget.initialSelection);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rfidProvider ??= context.read<RFIDScannerProvider>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _rfidSubscription?.cancel();
    // Arrêter le scanner RFID quand on quitte l'écran
    _rfidProvider?.stopScanning();
    super.dispose();
  }

  List<Animal> _getAvailableAnimals() {
    final animalProvider = context.read<AnimalProvider>();
    List<Animal> animals = animalProvider.animals;

    // ✅ Si on filtre par lot, afficher seulement les animaux DISPONIBLES (pas déjà dans CE lot)
    if (widget.animalIdsInLot != null) {
      animals =
          animals.where((a) => !widget.animalIdsInLot!.contains(a.id)).toList();
    }

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
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Text(AppLocalizations.of(context)
                  .translate(AppStrings.animalAlreadyScanned)
                  .replaceAll('{name}', animal.displayName)),
            ),
          ],
        ),
        backgroundColor: AppConstants.warningOrange,
        duration: AppConstants.snackBarDurationShort,
      ),
    );
  }

  void _showSuccessFeedback(Animal animal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Text(AppLocalizations.of(context)
                  .translate(AppStrings.animalAdded)
                  .replaceAll('{name}', animal.displayName)),
            ),
          ],
        ),
        backgroundColor: AppConstants.successGreen,
        duration: AppConstants.snackBarDurationShort,
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
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate(AppStrings.noAnimalAvailable)),
          backgroundColor: AppConstants.warningOrange,
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
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate(AppStrings.animalNotFound)),
            backgroundColor: AppConstants.statusDanger,
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
    final title = widget.title.isEmpty
        ? AppLocalizations.of(context).translate(AppStrings.identifyAnimals)
        : widget.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (_selectedAnimals.isNotEmpty &&
              widget.mode == AnimalFinderMode.multiple)
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: AppConstants.spacingMedium),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingSmall, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius:
                        BorderRadius.circular(AppConstants.spacingMedium),
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
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.searchEidOfficialVisual),
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
          Expanded(
            child: Column(
              children: [
                if (_selectedAnimals.isNotEmpty &&
                    widget.mode == AnimalFinderMode.multiple)
                  _buildSelectedAnimalsSection(context),
                Expanded(
                  child: _searchQuery.isEmpty && _selectedAnimals.isEmpty
                      ? _buildEmptyState(context)
                      : _buildSearchResults(context),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
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
                      rfidProvider.isScanning
                          ? AppLocalizations.of(context)
                              .translate(AppStrings.stop)
                          : AppLocalizations.of(context)
                              .translate(AppStrings.scanRfid),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: rfidProvider.isScanning
                          ? AppConstants.statusDanger
                          : AppConstants.primaryBlue,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMedium),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _startCameraScan,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(AppLocalizations.of(context)
                        .translate(AppStrings.camera)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMedium),
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
              label: Text(
                  '${AppLocalizations.of(context).translate(AppStrings.done)} (${_selectedAnimals.length})'),
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: AppConstants.logoSize,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          Text(
            AppLocalizations.of(context)
                .translate(AppStrings.scanOrSearchAnimals),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAnimalsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      color: Colors.green.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle,
                  color: Colors.green.shade700,
                  size: AppConstants.iconSizeRegular),
              const SizedBox(width: AppConstants.spacingExtraSmall),
              Text(
                '${AppLocalizations.of(context).translate(AppStrings.selected)} (${_selectedAnimals.length})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingExtraSmall),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedAnimals.map((animal) {
              return Chip(
                avatar:
                    const Icon(Icons.pets, size: AppConstants.spacingMedium),
                label: Text(
                  animal.displayName,
                  style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
                ),
                deleteIcon:
                    const Icon(Icons.close, size: AppConstants.spacingMedium),
                onDeleted: () => _removeAnimal(animal),
                backgroundColor: Colors.white,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    final availableAnimals = _getAvailableAnimals();

    if (availableAnimals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: AppConstants.iconSizeLarge,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Text(
              AppLocalizations.of(context).translate(AppStrings.noAnimalFound),
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.tryAnotherIdentifier),
              style: TextStyle(
                fontSize: AppConstants.fontSizeBody,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
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
                if (animal.currentEid != null)
                  '${AppLocalizations.of(context).translate(AppStrings.eidLabel)}: ${animal.currentEid}',
                if (animal.officialNumber != null)
                  '${AppLocalizations.of(context).translate(AppStrings.numberShort)}: ${animal.officialNumber}',
                if (animal.visualId != null)
                  '${AppLocalizations.of(context).translate(AppStrings.idLabel)}: ${animal.visualId}',
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

  Widget _buildAnimalTable(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.selectedAnimals),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Card(
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text(AppLocalizations.of(context)
                          .translate(AppStrings.eidLabel))),
                  DataColumn(
                      label: Text(AppLocalizations.of(context)
                          .translate(AppStrings.visualId))),
                  const DataColumn(label: Text('')),
                ],
                rows: _selectedAnimals.map((animal) {
                  return DataRow(
                    cells: [
                      DataCell(
                          Text(animal.currentEid ?? animal.visualId ?? '-')),
                      DataCell(Text(animal.visualId ?? '-')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.close,
                              size: AppConstants.iconSizeSmall),
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
