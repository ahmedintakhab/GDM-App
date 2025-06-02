import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

Future<void> generateAndSavePdf(BuildContext context, List<Map<String, dynamic>> weightData) async {
  final localizations = AppLocalizations.of(context)!;

  try {
    // Create a new PDF document
    final pdf = pw.Document();

    // Add a page with a table of weight data
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              localizations.weightTrackingReport,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
                '${localizations.generatedOn} ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
              },
              children: [
                // Table header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        localizations.dateHeader,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                     localizations.weightHeader,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                       localizations.unitHeader,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // Table rows from weightData
                ...weightData.map((entry) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(entry['date']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(entry['weight'].toStringAsFixed(1)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(entry['unit']),
                    ),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );

    // Save the PDF to a temporary file
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/weight_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Share the PDF file
    await Share.shareXFiles([XFile(file.path)], text: localizations.weightTrackingReport);

    Utils().toastMessage(localizations.pdfGeneratedSuccess);
  } catch (e) {
    if (kDebugMode) {
      print('Error generating PDF: $e');
    }
    Utils().toastMessage('${localizations.errorGeneratingPdf} $e');
    rethrow; // Rethrow to allow caller to handle the error
  }
}