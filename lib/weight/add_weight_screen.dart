import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/weight/add_weight_dialogbox.dart';
import 'package:gdm_app/weight/view_weight_summary.dart';
import 'package:gdm_app/weight/weight_graph.dart';

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
          'isExpanded': false,
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

  void _handleItemTap(int index) {
    setState(() {
      _weightData[index]['isExpanded'] = !(_weightData[index]['isExpanded'] ?? false);
    });
  }

  Future<void> _generateAndSavePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      // ... (keep your existing PDF generation code)
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
          'Add Weight',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5AA189),
      ),
      body: Column(
        children: [
          // Graph Container (Fixed)
          Container(
            height: 250,
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
                );
              },
            ),
          ),
          // Scrollable Weight Summary
          Expanded(
            child: WeightSummaryList(
              isLoading: _isLoading,
              errorMessage: _errorMessage,
              weightData: _weightData,
              onItemTap: _handleItemTap,
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
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF5AA189),
        tooltip: 'Add Weight',
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
                  : const Text('PDF',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              icon: const Icon(Icons.download, color: Colors.white),
              backgroundColor: const Color(0xFF5AA189),
              tooltip: 'Download PDF',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddWeightDialogBox(),
                );
              },
              label: const Text('Weight',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.add_circle, color: Colors.white),
              backgroundColor: const Color(0xFF5AA189),
              tooltip: 'Add Weight',
            ),
          ),
        ],
      ),
    );
  }
}