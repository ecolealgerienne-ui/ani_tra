import 'package:flutter/material.dart';
import 'dart:async';

class SyncProvider extends ChangeNotifier {
  bool _isOnline = false;
  bool _isSyncing = false;
  DateTime? _lastSyncDate;
  int _pendingDataCount = 0;
  String? _syncError;

  // Getters
  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncDate => _lastSyncDate;
  int get pendingDataCount => _pendingDataCount;
  String? get syncError => _syncError;

  // Simulate network status
  void toggleOnlineStatus() {
    _isOnline = !_isOnline;
    _syncError = null;
    notifyListeners();
  }

  void setOnline(bool online) {
    _isOnline = online;
    _syncError = null;
    notifyListeners();
  }

  // Add pending data
  void addPendingData(int count) {
    _pendingDataCount += count;
    notifyListeners();
  }

  void incrementPendingData() {
    _pendingDataCount++;
    notifyListeners();
  }

  // Simulate synchronization
  Future<bool> synchronize() async {
    if (_isSyncing) return false;

    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate random failure (10% chance)
      if (!_isOnline && DateTime.now().millisecond % 10 == 0) {
        throw Exception('Network error: Unable to reach server');
      }

      // Success
      _lastSyncDate = DateTime.now();
      _pendingDataCount = 0;
      _isSyncing = false;
      notifyListeners();

      return true;
    } catch (e) {
      _syncError = e.toString();
      _isSyncing = false;
      notifyListeners();

      return false;
    }
  }

  // Clear error
  void clearError() {
    _syncError = null;
    notifyListeners();
  }

  // Simulate auto-sync (call this periodically in production)
  Future<void> autoSync() async {
    if (_isOnline && _pendingDataCount > 0 && !_isSyncing) {
      await synchronize();
    }
  }
}
