import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:intl/intl.dart';

class ViewGlucoseSummary extends StatefulWidget {
  const ViewGlucoseSummary({super.key});

  @override
  State<ViewGlucoseSummary> createState() => _ViewGlucoseSummaryState();
}

class _ViewGlucoseSummaryState extends State<ViewGlucoseSummary> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  bool _isGeneratingPdf = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _glucoseData = [];

  @override
  void initState() {
    super.initState();
    _fetchGlucoseData();
  }

  Future<void> _fetchGlucoseData() async {
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

      QuerySnapshot glucoseSnapshot = await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('glucoseEntries')
          .orderBy('dateTime', descending: true)
          .get();

      _glucoseData = glucoseSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = (data['dateTime'] as Timestamp?)?.toDate();
        return {
          'date': timestamp != null ? DateFormat('MMMM d, yyyy').format(timestamp) : '',
          'time': timestamp != null ? DateFormat('h:mm a').format(timestamp) : '',
          'reading': data['glucoseLevel'] ?? '',
          'mealContext': data['mealOption'] ?? 'Unknown',
        };
      }).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching glucose data: $e';
        _isLoading = false;
      });
      Utils().toastMessage('Error fetching glucose data: $e');
    }
  }

  Future<void> _generateAndSavePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Glucose Summary Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20.h),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Time',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Reading',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Meal Context',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ..._glucoseData.map((entry) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(entry['date']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(entry['time']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(entry['reading']),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Text(entry['mealContext']),
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

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/glucose_summary_$timestamp.pdf');

      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Glucose Summary Report',
      );

      Utils().toastMessage('PDF report saved to ${file.path} and shared');
    } catch (e) {
      if (kDebugMode) {
        print('Error generating PDF: $e');
      }
      Utils().toastMessage('Error generating PDF: $e');
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Glucose Summary',
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
                    if (_glucoseData.isEmpty)
                      const Center(child: Text('No glucose data available'))
                    else ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(color: Colors.grey),
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.grey[200]),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Date',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Time',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Reading',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Meal Context',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            ..._glucoseData.map((entry) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      entry['date'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      entry['time'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      entry['reading'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      entry['mealContext'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                ],
              ),
            ),
          ),
          if (!_isLoading && _errorMessage == null && _glucoseData.isNotEmpty)
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