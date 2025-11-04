// lib/services/pdf_export_service.dart

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../models/animal.dart';

class PdfExportService {
  /// Génère l'inventaire des animaux
  Future<void> generateInventoryPdf({
    required List<Animal> animals,
    required String farmName,
  }) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(farmName, 'Inventaire des animaux', dateStr),
            pw.SizedBox(height: 20),
            _buildInventoryTable(animals),
          ],
        ),
      ),
    );

    await _savePdf(pdf, 'inventaire_$dateStr.pdf');
  }

  // ========== WIDGETS INTERNES ==========

  pw.Widget _buildHeader(String farmName, String title, String date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          farmName,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Date: $date',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildInventoryTable(List<Animal> animals) {
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
          'Total: ${alive.length} animaux',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('N° officiel', bold: true),
                _buildTableCell('EID', bold: true),
                _buildTableCell('Sexe', bold: true),
                _buildTableCell('Race', bold: true),
                _buildTableCell('Age', bold: true),
              ],
            ),
            ...alive.map((animal) => pw.TableRow(
                  children: [
                    _buildTableCell(animal.officialNumber ?? '-'),
                    _buildTableCell(animal.currentEid ?? '-'),
                    _buildTableCell(_getSexLabel(animal.sex)),
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
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _getSexLabel(AnimalSex sex) {
    switch (sex) {
      case AnimalSex.male:
        return 'M';
      case AnimalSex.female:
        return 'F';
    }
  }

  /// Sauvegarde et téléchargement du PDF
  Future<void> _savePdf(pw.Document pdf, String filename) async {
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
        throw Exception('Impossible d\'accéder aux téléchargements');
      }

      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);
    }
  }
}
