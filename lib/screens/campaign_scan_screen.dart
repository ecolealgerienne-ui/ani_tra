// lib/screens/campaign_scan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../providers/campaign_provider.dart';
import '../providers/animal_provider.dart';
import '../providers/sync_provider.dart';
import '../i18n/app_localizations.dart';

class CampaignScanScreen extends StatefulWidget {
  const CampaignScanScreen({super.key});

  @override
  State<CampaignScanScreen> createState() => _CampaignScanScreenState();
}

class _CampaignScanScreenState extends State<CampaignScanScreen> {
  bool _isScanning = false;
  String? _lastScanResult;
  final _random = Random();

  Future<void> _simulateScan() async {
    final campaignProvider = context.read<CampaignProvider>();
    final animalProvider = context.read<AnimalProvider>();

    if (campaignProvider.activeCampaign == null) return;

    setState(() {
      _isScanning = true;
      _lastScanResult = null;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Simulate scan delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Obtenir un animal aléatoire de la liste
      final animals = animalProvider.animals;

      if (animals.isEmpty) {
        if (!mounted) return;
        setState(() {
          _lastScanResult = 'error';
          _isScanning = false;
        });
        return;
      }

      // Sélectionner un animal aléatoire
      final animal = animals[_random.nextInt(animals.length)];

      // Check if already scanned
      final isDuplicate =
          campaignProvider.isAnimalScannedInActiveCampaign(animal.id);

      if (isDuplicate) {
        // Duplicate - error feedback
        HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        HapticFeedback.heavyImpact();

        setState(() {
          _lastScanResult = 'duplicate';
          _isScanning = false;
        });
      } else {
        // Success - add to campaign
        campaignProvider.addScannedAnimal(animal.id);
        HapticFeedback.heavyImpact();

        setState(() {
          _lastScanResult = 'success';
          _isScanning = false;
        });
      }
    } catch (e) {
      setState(() {
        _lastScanResult = 'error';
        _isScanning = false;
      });
    }
  }

  void _completeCampaign() {
    final campaignProvider = context.read<CampaignProvider>();
    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();

    final campaign = campaignProvider.activeCampaign;
    if (campaign == null) return;

    // Generate treatments
    final treatments =
        campaignProvider.generateTreatmentsFromCampaign(campaign);
    for (final treatment in treatments) {
      animalProvider.addTreatment(treatment);
    }

    // Complete campaign
    campaignProvider.completeCampaign(campaign.id);

    // Add to sync queue
    syncProvider.addPendingData(treatments.length + 1);

    if (!mounted) return;

    // Show success and go back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Campagne terminée: ${campaign.animalCount} animaux traités',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final campaignProvider = context.watch<CampaignProvider>();
    final campaign = campaignProvider.activeCampaign;
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    if (campaign == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(
          child: Text('Aucune campagne active'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(campaign.name),
        actions: [
          if (campaign.animalCount > 0)
            TextButton(
              onPressed: _completeCampaign,
              child: const Text(
                'TERMINER',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Campaign Info Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Column(
              children: [
                Text(
                  campaign.productName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(dateFormat.format(campaign.campaignDate)),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.warning_amber,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(dateFormat.format(campaign.withdrawalEndDate)),
                  ],
                ),
              ],
            ),
          ),

          // Scan Counter
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  l10n.translate('animals_scanned'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  campaign.animalCount.toString(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),

          // Scan Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ElevatedButton(
                    onPressed: _isScanning ? null : _simulateScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isScanning
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.nfc, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                l10n.translate('simulate_scan'),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Scan Result Feedback
                if (_lastScanResult != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _lastScanResult == 'success'
                          ? Colors.green.shade50
                          : _lastScanResult == 'duplicate'
                              ? Colors.orange.shade50
                              : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _lastScanResult == 'success'
                            ? Colors.green
                            : _lastScanResult == 'duplicate'
                                ? Colors.orange
                                : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _lastScanResult == 'success'
                              ? Icons.check_circle
                              : _lastScanResult == 'duplicate'
                                  ? Icons.warning_amber
                                  : Icons.error,
                          color: _lastScanResult == 'success'
                              ? Colors.green
                              : _lastScanResult == 'duplicate'
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _lastScanResult == 'success'
                                ? 'Animal ajouté avec succès'
                                : _lastScanResult == 'duplicate'
                                    ? l10n.translate('already_scanned')
                                    : 'Erreur de scan',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Complete Button
          if (campaign.animalCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _completeCampaign,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.translate('save_campaign')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
