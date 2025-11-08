// lib/screens/sale_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../models/animal.dart';
import '../../models/movement.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  Animal? _scannedAnimal;
  final _priceController = TextEditingController();
  final _buyerNameController = TextEditingController();
  final _buyerIdController = TextEditingController();
  bool _isScanning = false;
  final _random = Random();

  @override
  void dispose() {
    _priceController.dispose();
    _buyerNameController.dispose();
    _buyerIdController.dispose();
    super.dispose();
  }

  Future<void> _simulateScanAnimal() async {
    setState(() => _isScanning = true);

    HapticFeedback.mediumImpact();
    await Future.delayed(AppConstants.longAnimation);

    final animalProvider = context.read<AnimalProvider>();

    try {
      // Obtenir les animaux vendables (vivants, pas de délai de rémanence)
      final animals = animalProvider.animals
          .where((a) => a.status == AnimalStatus.alive)
          .toList();

      if (animals.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate(AppStrings.noAnimalsAvailable)),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isScanning = false);
        return;
      }

      // Sélectionner un animal aléatoire
      final animal = animals[_random.nextInt(animals.length)];

      // Check if animal can be sold (vérifier délai de rémanence)
      final treatments = animalProvider.getAnimalTreatments(animal.id);
      final hasActiveWithdrawal = treatments.any((t) => t.isWithdrawalActive);

      if (hasActiveWithdrawal) {
        HapticFeedback.heavyImpact();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)
                  .translate(AppStrings.withdrawalPeriodActive)),
              backgroundColor: Colors.red,
              duration: AppConstants.snackBarDurationLong,
            ),
          );
        }
        setState(() => _isScanning = false);
        return;
      }

      setState(() {
        _scannedAnimal = animal;
        _isScanning = false;
      });

      HapticFeedback.heavyImpact();
    } catch (e) {
      setState(() => _isScanning = false);
    }
  }

  void _confirmSale() {
    if (_scannedAnimal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.scanAnimal)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_buyerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate(AppStrings.pleaseEnterBuyerName)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.invalidPrice)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Create sale movement
    final movement = Movement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      animalId: _scannedAnimal!.id,
      type: MovementType.sale,
      movementDate: DateTime.now(),
      price: price,
      toFarmId:
          _buyerIdController.text.isNotEmpty ? _buyerIdController.text : null,
      notes:
          '${AppLocalizations.of(context).translate(AppStrings.buyer)}: ${_buyerNameController.text}',
      createdAt: DateTime.now(),
    );

    animalProvider.addMovement(movement);
    syncProvider.incrementPendingData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${AppLocalizations.of(context).translate(AppStrings.saleRecorded)}: ${price.toStringAsFixed(2)}€'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate(AppStrings.recordSale)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Step 1: Scan Animal
          Text(
            AppLocalizations.of(context).translate(AppStrings.step1ScanAnimal),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          if (_scannedAnimal == null)
            SizedBox(
              height: 100,
              child: ElevatedButton(
                onPressed: _isScanning ? null : _simulateScanAnimal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isScanning
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.nfc, size: 36),
                          const SizedBox(height: 8),
                          Text(
                              AppLocalizations.of(context)
                                  .translate(AppStrings.scanAnimal),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
              ),
            )
          else
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(_scannedAnimal!.officialNumber ??
                    AppConstants.notAvailable),
                subtitle: Text(_scannedAnimal!.displayName),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _scannedAnimal = null;
                    });
                  },
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Step 2: Buyer Information
          if (_scannedAnimal != null) ...[
            Text(
              AppLocalizations.of(context).translate(AppStrings.step2BuyerInfo),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _buyerNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.buyerName),
                prefixIcon: const Icon(Icons.person),
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.buyerNameHint),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _buyerIdController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.buyerIdOptional),
                prefixIcon: const Icon(Icons.badge),
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.buyerIdHint),
              ),
            ),

            const SizedBox(height: 24),

            // Step 3: Enter Price
            Text(
              AppLocalizations.of(context).translate(AppStrings.step3SalePrice),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).translate(AppStrings.priceEur),
                prefixIcon: const Icon(Icons.euro),
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.priceHint),
              ),
            ),

            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _confirmSale,
                icon: const Icon(Icons.check),
                label: Text(AppLocalizations.of(context)
                    .translate(AppStrings.confirmSale)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
