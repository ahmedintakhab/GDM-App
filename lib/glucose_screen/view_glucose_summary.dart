import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

import 'glucose_pdf_generator.dart';

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

      QuerySnapshot glucoseSnapshot = await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('glucoseEntries')
          .orderBy('dateTime', descending: true)
          .get();

      _glucoseData = glucoseSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = (data['dateTime'] as Timestamp?)?.toDate();
        final glucoseValue = (data['glucoseValue'] as num?)?.toDouble() ?? 0.0;
        final unit = data['glucoseLevel']?.split(' ')[1] ?? 'Unknown';
        // Format value as integer if no decimal part, else two decimal places
        final displayValue = glucoseValue == glucoseValue.truncateToDouble()
            ? glucoseValue.toInt().toString()
            : glucoseValue.toStringAsFixed(2);
        return {
          'date': timestamp != null ? DateFormat('MMMM d, yyyy').format(timestamp) : '',
          'time': timestamp != null ? DateFormat('h:mm a').format(timestamp) : '',
          'reading': '$displayValue $unit',
          'mealContext': data['mealOption'] ?? 'Unknown',
          'isExpanded': false,
        };
      }).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '${l10n.errorFetchingGlucose} $e';
        _isLoading = false;
      });
      Utils().toastMessage('${l10n.errorFetchingGlucose} $e');
    }
  }

  Future<void> _generateAndSavePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      await generateAndSaveGlucosePdf(_glucoseData,context);
    } catch (e) {
      // Error is already handled in generateAndSaveGlucosePdf with toast
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
          l10n.glucoseSummary,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5AA189),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0XFF5AA189)))
                : _errorMessage != null
                ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
                : _glucoseData.isEmpty
                ?  Center(child: Text(l10n.noGlucoseData))
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _glucoseData.length,
              itemBuilder: (context, index) {
                return GlucoseEntryContainer(
                  data: _glucoseData[index],
                  isExpanded: _glucoseData[index]['isExpanded'] ?? false,
                  onTap: () {
                    setState(() {
                      _glucoseData[index]['isExpanded'] =
                      !(_glucoseData[index]['isExpanded'] ?? false);
                    });
                  },
                );
              },
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
                      buttonText: _isGeneratingPdf ? '' : l10n.downloadPdf,
                      leadingIcon: Icon(Icons.download, color: Colors.white,),
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

class GlucoseEntryContainer extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isExpanded;
  final VoidCallback onTap;

  const GlucoseEntryContainer({
    super.key,
    required this.data,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<GlucoseEntryContainer> createState() => _GlucoseEntryContainerState();
}

class _GlucoseEntryContainerState extends State<GlucoseEntryContainer> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 2,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data['date'],
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5AA189),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.reading, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        Text(widget.data['reading'], style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.mealContext, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        Text(widget.data['mealContext'], style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.time, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        Text(widget.data['time'], style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}