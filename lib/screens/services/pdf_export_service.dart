// lib/services/pdf_export_service.dart

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../models/animal.dart';

import '../../utils/constants.dart';

class PdfExportService {
  /// Génère l'inventaire des animaux
  Future<void> generateInventoryPdf({
    required List<Animal> animals,
    required String farmName,
    required Map<String, String> translations,
  }) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(
              farmName,
              translations['animalInventory'] ?? 'Inventaire des animaux',
              dateStr,
              translations['date'] ?? 'Date',
            ),
            pw.SizedBox(height: 20),
            _buildInventoryTable(animals, translations),
          ],
        ),
      ),
    );

    await _savePdf(
      pdf,
      'inventaire_$dateStr.pdf',
      translations['cannotAccessDownloads'] ??
          'Impossible d\'accéder aux téléchargements',
    );
  }

  // ========== WIDGETS INTERNES ==========

  pw.Widget _buildHeader(
    String farmName,
    String title,
    String date,
    String dateLabel,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          farmName,
          style: pw.TextStyle(fontSize: AppConstants.fontSizeLarge, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: AppConstants.fontSizeMedium, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '$dateLabel: $date',
              style: const pw.TextStyle(fontSize: AppConstants.fontSizeMicro, color: PdfColors.grey700),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildInventoryTable(
    List<Animal> animals,
    Map<String, String> translations,
  ) {
    final alive = animals.where((a) => a.status == AnimalStatus.alive).toList()
      ..sort((a, b) {
        final aNum = a.officialNumber ?? a.currentEid ?? '';
        final bNum = b.officialNumber ?? b.currentEid ?? '';
        return aNum.compareTo(bNum);
      });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '${translations['total'] ?? 'Total'}: ${alive.length} ${translations['animalsCount'] ?? 'animaux'}',
          style: pw.TextStyle(fontSize: AppConstants.fontSizeSmall, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell(translations['officialNumber'] ?? 'N° officiel',
                    bold: true),
                _buildTableCell(translations['eid'] ?? 'EID', bold: true),
                _buildTableCell(translations['sex'] ?? 'Sexe', bold: true),
                _buildTableCell(translations['breed'] ?? 'Race', bold: true),
                _buildTableCell(translations['age'] ?? 'Age', bold: true),
              ],
            ),
            ...alive.map((animal) => pw.TableRow(
                  children: [
                    _buildTableCell(animal.officialNumber ?? '-'),
                    _buildTableCell(animal.currentEid ?? '-'),
                    _buildTableCell(_getSexLabel(animal.sex, translations)),
                    _buildTableCell(animal.breedId ?? '-'),
                    _buildTableCell('${animal.ageInMonths}m'),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(AppConstants.spacingTiny),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _getSexLabel(AnimalSex sex, Map<String, String> translations) {
    switch (sex) {
      case AnimalSex.male:
        return translations['male'] ?? 'M';
      case AnimalSex.female:
        return translations['female'] ?? 'F';
    }
  }

  /// Sauvegarde et téléchargement du PDF
  Future<void> _savePdf(
    pw.Document pdf,
    String filename,
    String errorMessage,
  ) async {
    final bytes = await pdf.save();

    if (kIsWeb) {
      // Web: Téléchargement direct
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile: Sauvegarde dans Downloads
      final dir = await getDownloadsDirectory();
      if (dir == null) {
        throw Exception(errorMessage);
      }

      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);
    }
  }
}
