// lib/providers/rfid_scanner_provider.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/animal.dart';

class RFIDScannerProvider extends ChangeNotifier {
  bool _isScanning = false;
  StreamController<String>? _eidStreamController;
  Timer? _scanTimer;
  final _random = Random();

  bool get isScanning => _isScanning;

  void startScanning(List<Animal> availableAnimals) {
    if (_isScanning) return;

    _isScanning = true;
    _eidStreamController = StreamController<String>.broadcast();

    _scanTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (availableAnimals.isEmpty) return;

      final animal = availableAnimals[_random.nextInt(availableAnimals.length)];
      if (animal.currentEid != null) {
        _eidStreamController?.add(animal.currentEid!);
      }
    });

    notifyListeners();
  }

  void stopScanning() {
    _isScanning = false;
    _scanTimer?.cancel();
    _eidStreamController?.close();
    _eidStreamController = null;
    notifyListeners();
  }

  Stream<String>? get eidStream => _eidStreamController?.stream;

  @override
  void dispose() {
    stopScanning();
    super.dispose();
  }
}
