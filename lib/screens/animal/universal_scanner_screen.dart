// lib/screens/universal_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../models/scan_result.dart';
import '../../providers/animal_provider.dart';

class UniversalScannerScreen extends StatefulWidget {
  final String mode; // 'identify' ou 'register'
  final Function(ScanResult)? onScanSuccess;

  const UniversalScannerScreen({
    super.key,
    this.mode = 'identify',
    this.onScanSuccess,
  });

  @override
  State<UniversalScannerScreen> createState() => _UniversalScannerScreenState();
}

class _UniversalScannerScreenState extends State<UniversalScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() => _isProcessing = true);

    try {
      final scanResult = ScanResult.parse(barcode.rawValue!);
      HapticFeedback.mediumImpact();

      if (widget.mode == 'identify') {
        await _handleIdentifyMode(scanResult);
      } else {
        if (widget.onScanSuccess != null) {
          widget.onScanSuccess!(scanResult);
        }
        if (mounted) Navigator.pop(context, scanResult);
      }
    } catch (e) {
      _showError('Erreur de scan : $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleIdentifyMode(ScanResult scanResult) async {
    final animalProvider = context.read<AnimalProvider>();
    final animal = scanResult.findMatchingAnimal(animalProvider.animals);

    if (animal != null) {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          '/animal-detail',
          arguments: animal.id,
        );
      }
    } else {
      _showNotFoundDialog(scanResult);
    }
  }

  void _showNotFoundDialog(ScanResult scanResult) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Animal non trouvé'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Valeur : ${scanResult.rawValue}'),
            const SizedBox(height: 16),
            const Text('Voulez-vous enregistrer ce nouvel animal ?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/add-animal',
                arguments: scanResult,
              );
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isProcessing
                        ? Icons.hourglass_empty
                        : Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isProcessing
                        ? 'Traitement en cours...'
                        : 'Scannez un code-barres, EID ou ID visuel',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.keyboard),
                label: const Text('Saisie manuelle'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
