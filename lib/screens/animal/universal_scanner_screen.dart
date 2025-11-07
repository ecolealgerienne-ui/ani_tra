// lib/screens/universal_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../models/scan_result.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';

class UniversalScannerScreen extends StatefulWidget {
  final String? mode;
  final Function(ScanResult)? onScanSuccess;
  final String title;
  final String hint;

  const UniversalScannerScreen({
    super.key,
    this.mode,
    this.onScanSuccess,
    this.title = 'Scanner',
    this.hint = 'Scannez un code-barres, EID ou ID visuel',
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

      if (widget.onScanSuccess != null) {
        widget.onScanSuccess!(scanResult);
      }

      if (mounted) {
        Navigator.pop(context, scanResult);
      }
    } catch (e) {
      _showError('Erreur de scan : $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
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
        title: Text(widget.title),
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
                color: Colors.black.withValues(alpha: 0.7),
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
                        ? AppLocalizations.of(context)
                            .translate(AppStrings.processing)
                        : widget.hint,
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
