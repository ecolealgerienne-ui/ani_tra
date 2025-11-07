// lib/screens/export_registry_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/pdf_export_service.dart';
import '../../providers/animal_provider.dart';
import '../../providers/settings_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';

class ExportRegistryScreen extends StatefulWidget {
  const ExportRegistryScreen({super.key});

  @override
  State<ExportRegistryScreen> createState() => _ExportRegistryScreenState();
}

class _ExportRegistryScreenState extends State<ExportRegistryScreen> {
  String? _generatingDocId;

  Future<void> _generateDocument(BuildContext context, String docType) async {
    setState(() => _generatingDocId = docType);

    try {
      final animalProvider = context.read<AnimalProvider>();
      final settings = context.read<SettingsProvider>();

      final pdfService = PdfExportService();

      switch (docType) {
        case 'registre_complet':
        case 'inventaire':
          await pdfService.generateInventoryPdf(
            animals: animalProvider.animals,
            farmName: settings.farmName ?? 'Mon Élevage',
          );
          break;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.pdfDownloaded)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '❌ ${AppLocalizations.of(context).translate(AppStrings.error)}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _generatingDocId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate(AppStrings.exportDocuments)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDocumentCard(
            context: context,
            id: 'registre_complet',
            icon: Icons.description,
            iconColor: Colors.blue,
            title: 'Registre complet',
            subtitle: 'Inventaire du cheptel',
            enabled: true,
          ),
          const SizedBox(height: 12),
          _buildDocumentCard(
            context: context,
            id: 'inventaire',
            icon: Icons.list_alt,
            iconColor: Colors.green,
            title: 'Inventaire des animaux',
            subtitle: 'Liste complète du cheptel',
            enabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required BuildContext context,
    required String id,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool enabled,
  }) {
    final isGenerating = _generatingDocId == id;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: enabled && !isGenerating
            ? () => _generateDocument(context, id)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isGenerating)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.download,
                  color: enabled ? iconColor : Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
