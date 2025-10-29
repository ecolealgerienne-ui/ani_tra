// lib/screens/sale_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/animal_provider.dart';
import '../providers/qr_provider.dart';
import '../providers/sync_provider.dart';
import '../models/animal.dart';
import '../models/movement.dart';
import '../i18n/app_localizations.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  Animal? _scannedAnimal;
  final _priceController = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _simulateScanAnimal() async {
    setState(() => _isScanning = true);

    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 500));

    final animalProvider = context.read<AnimalProvider>();

    try {
      final animal = animalProvider.simulateScan();

      // Check if animal can be sold
      final treatments = animalProvider.getAnimalTreatments(animal.id);
      final hasActiveWithdrawal = treatments.any((t) => t.isWithdrawalActive);

      if (hasActiveWithdrawal) {
        HapticFeedback.heavyImpact();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Impossible: Délai de rémanence en cours'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
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

  Future<void> _simulateScanQR() async {
    final qrProvider = context.read<QRProvider>();

    setState(() => _isScanning = true);

    HapticFeedback.mediumImpact();

    // Simulate QR scan
    final mockQR = qrProvider.generateMockQR('buyer');
    await qrProvider.scanQRCode(mockQR);

    setState(() => _isScanning = false);

    if (qrProvider.validatedUser != null) {
      HapticFeedback.heavyImpact();
    }
  }

  void _confirmSale() {
    final qrProvider = context.read<QRProvider>();
    final buyer = qrProvider.validatedUser;

    if (_scannedAnimal == null || buyer == null) return;

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prix invalide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Create sale movement
    final movement = Movement(
      animalId: _scannedAnimal!.id,
      type: MovementType.sale,
      movementDate: DateTime.now(),
      price: price,
      toFarmId: buyer['id'],
      buyerQrSignature: qrProvider.lastScannedQR,
      notes: 'Acheteur: ${buyer['name']}',
    );

    animalProvider.addMovement(movement);
    syncProvider.incrementPendingData();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vente enregistrée: ${price.toStringAsFixed(2)}€'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final qrProvider = context.watch<QRProvider>();
    final buyer = qrProvider.validatedUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('record_sale')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Step 1: Scan Animal
          Text(
            'Étape 1: Scanner l\'animal',
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
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.nfc, size: 36),
                          SizedBox(height: 8),
                          Text('Scanner Animal',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
              ),
            )
          else
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(_scannedAnimal!.officialNumber ?? 'N/A'),
                subtitle: Text(_scannedAnimal!.eid),
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

          // Step 2: Scan Buyer QR
          if (_scannedAnimal != null) ...[
            Text(
              'Étape 2: Scanner QR Code Acheteur',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (buyer == null)
              SizedBox(
                height: 100,
                child: ElevatedButton(
                  onPressed: _isScanning ? null : _simulateScanQR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: _isScanning
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner, size: 36),
                            SizedBox(height: 8),
                            Text('Scanner QR Acheteur',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                ),
              )
            else
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_user, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Acheteur Validé',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              qrProvider.clearValidation();
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Text('Nom: ${buyer['name']}'),
                      Text('Organisation: ${buyer['organization']}'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],

          // Step 3: Enter Price
          if (buyer != null) ...[
            Text(
              'Étape 3: Prix de vente',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Prix (€)',
                prefixIcon: Icon(Icons.euro),
                hintText: '120.00',
              ),
            ),

            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _confirmSale,
                icon: const Icon(Icons.check),
                label: Text(l10n.translate('confirm_sale')),
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
