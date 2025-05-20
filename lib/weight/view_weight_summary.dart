import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeightSummaryList extends StatelessWidget {
  final List<Map<String, dynamic>> weightData;
  final bool isGeneratingPdf;
  final Function() onGeneratePdf;

  const WeightSummaryList({
    super.key,
    required this.weightData,
    required this.isGeneratingPdf,
    required this.onGeneratePdf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: weightData.isEmpty
              ? const Center(child: Text('No weight data available'))
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: weightData.length,
            itemBuilder: (context, index) {
              return WeightEntryContainer(
                data: weightData[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class WeightEntryContainer extends StatelessWidget {
  final Map<String, dynamic> data;

  const WeightEntryContainer({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data['date'],
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              '${data['weight'].toStringAsFixed(1)} ${data['unit']}',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}