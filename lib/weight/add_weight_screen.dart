import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/weight/add_weight_dialogbox.dart';
import 'package:gdm_app/weight/view_weight_summary.dart';
import 'package:gdm_app/weight/weight_graph.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'generate_weight_pdf.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  bool _isGeneratingPdf = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _weightData = [];
  bool _hasFetchedData = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetchedData) {
      _hasFetchedData = true; // Prevent multiple fetches
      _fetchWeightData();
    }
  }

  Future<void> _fetchWeightData() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = l10n.noUserLoggedIn;
          _isLoading = false;
        });
        return;
      }

      QuerySnapshot weightSnapshot = await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('weight')
          .orderBy('timestamp', descending: true)
          .get();

      _weightData = weightSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        String dateStr = data['date'] ?? '';
        DateTime parsedDate = dateStr.isNotEmpty
            ? DateFormat('dd MMM yyyy').parse(dateStr)
            : DateTime.now();
        return {
          'date': dateStr,
          'weight': double.tryParse(data['weight']?.toString() ?? '0') ?? 0.0,
          'unit': data['unit'] ?? 'kg',
          'timestamp': (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'parsedDate': parsedDate,
          'isExpanded': false,
        };
      }).toList();

      // Sort weightData for graph (chronological order by parsedDate)
      _weightData.sort((a, b) => a['parsedDate'].compareTo(b['parsedDate']));

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '${l10n.errorFetchingWeightData} $e';
        _isLoading = false;
      });
      Utils().toastMessage('${l10n.errorFetchingWeightData} $e');
    }
  }

  // void _handleItemTap(int index) {
  //   setState(() {
  //     _weightData[index]['isExpanded'] = !(_weightData[index]['isExpanded'] ?? false);
  //   });
  // }

  Future<void> _generateAndSavePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      await generateAndSavePdf(context,_weightData);
    } catch (e) {
      // Error is already handled in generateAndSavePdf with toast
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          l10n.weightManagement,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5AA189),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0XFF5AA189),))
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : Column(
        children: [
          // Graph Container (Fixed)
          Container(
            height: 250.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double chartWidth = constraints.maxWidth;
                double barWidth = chartWidth > 600
                    ? 20.0
                    : chartWidth > 400
                    ? 15.0
                    : 13.0;

                return WeightGraph(
                  maxWidth: chartWidth,
                  barWidth: barWidth,
                  weightData: _weightData
                      .where((data) {
                    DateTime weekAgo = DateTime.now().subtract(const Duration(days: 7));
                    return data['parsedDate'].isAfter(weekAgo) ||
                        data['parsedDate'].isAtSameMomentAs(weekAgo);
                  })
                      .toList(),
                );
              },
            ),
          ),
          // Scrollable Weight Summary
          Expanded(
            child: WeightSummaryList(
              weightData: _weightData,
              // onItemTap: _handleItemTap,
              isGeneratingPdf: _isGeneratingPdf,
              onGeneratePdf: _generateAndSavePdf,
            ),
          ),
        ],
      ),
      floatingActionButton: _isLoading || _errorMessage != null || _weightData.isEmpty
          ? FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddWeightDialogBox(),
          ).then((_) => _fetchWeightData()); // Refresh data after dialog
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF5AA189),
        tooltip: l10n.addWeight,
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, bottom: 20.0),
            child: FloatingActionButton.extended(
              onPressed: _isGeneratingPdf ? null : _generateAndSavePdf,
              label: _isGeneratingPdf
                  ? const CircularProgressIndicator(color: Colors.white)
                  :  Text(
                l10n.pdfButton,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.download, color: Colors.white),
              backgroundColor: const Color(0xFF5AA189),
              tooltip: l10n.downloadPdf,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddWeightDialogBox(),
                ).then((_) => _fetchWeightData()); // Refresh data after dialog
              },
              label: Text(
                l10n.weightButton,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.add_circle, color: Colors.white),
              backgroundColor: const Color(0xFF5AA189),
              tooltip: l10n.addWeight,
            ),
          ),
        ],
      ),
    );
  }
}