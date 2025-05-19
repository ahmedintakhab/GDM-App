import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode;

class ViewWeightSummary extends StatefulWidget {
  const ViewWeightSummary({super.key});

  @override
  State<ViewWeightSummary> createState() => _ViewWeightSummaryState();
}

class _ViewWeightSummaryState extends State<ViewWeightSummary> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  bool _isGeneratingPdf = false; // State for PDF generation
  String? _errorMessage;
  List<Map<String, dynamic>> _weightData = [];

  @override
  void initState() {
    super.initState();
    _fetchWeightData();
  }

  Future<void> _fetchWeightData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'No user logged in';
          _isLoading = false;
        });
        return;
      }

      QuerySnapshot weightSnapshot = await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('weight')
          .orderBy('date', descending: true)
          .get();

      _weightData = weightSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'date': data['date'] ?? '',
          'weight': data['weight'] ?? '',
          'unit': data['unit'] ?? 'kg',
        };
      }).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching weight data: $e';
        _isLoading = false;
      });
      Utils().toastMessage('Error fetching weight data: $e');
    }
  }

  Future<void> _generateAndSavePdf() async {
    setState(() {
      _isGeneratingPdf = true; // Show loading indicator
    });

    try {
      // Create PDF document
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Weight Summary Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      // color: pw.PdfColor.fromInt(0xFFE0E0E0), // Light grey
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Weight',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Data Rows
                  ..._weightData.map((entry) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(entry['date']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${entry['weight']} ${entry['unit']}'),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      );

      // Try primary directory (Application Documents)
      Directory? directory;
      try {
        directory = await getApplicationDocumentsDirectory();
        if (kDebugMode) {
          print('Documents directory: ${directory.path}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to access documents directory: $e');
        }
        Utils().toastMessage('Failed to access documents directory: $e');
        // Fallback to temporary directory
        try {
          directory = await getTemporaryDirectory();
          if (kDebugMode) {
            print('Temporary directory: ${directory.path}');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Failed to access temporary directory: $e');
          }
          Utils().toastMessage('Failed to access temporary directory: $e');
          return;
        }
      }

      if (directory == null) {
        Utils().toastMessage('Unable to access storage directory');
        return;
      }

      // Create file path with timestamp to avoid overwriting
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/weight_summary_$timestamp.pdf');

      // Save the PDF file
      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Weight Summary Report',
      );

      Utils().toastMessage('PDF report saved to ${file.path} and shared');
    } catch (e) {
      if (kDebugMode) {
        print('Error generating PDF: $e');
      }
      Utils().toastMessage('Error generating PDF: $e');
    } finally {
      setState(() {
        _isGeneratingPdf = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weight Summary',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0XFF5AA189),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (_errorMessage != null)
                    Center(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (!_isLoading && _errorMessage == null)
                    if (_weightData.isEmpty)
                      const Center(child: Text('No weight data available'))
                    else ...[
                      Table(
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          // Header Row
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Weight',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          // Data Rows
                          ..._weightData.map((entry) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(entry['date']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('${entry['weight']} ${entry['unit']}'),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                ],
              ),
            ),
          ),
          if (!_isLoading && _errorMessage == null && _weightData.isNotEmpty)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomButton(
                      onTap: _isGeneratingPdf ? () {} : _generateAndSavePdf,
                      buttonText: _isGeneratingPdf ? '' : 'Generate Report',
                    ),
                    if (_isGeneratingPdf)
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}