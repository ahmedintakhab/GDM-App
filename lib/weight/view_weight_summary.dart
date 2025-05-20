import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeightSummaryList extends StatelessWidget {
  final List<Map<String, dynamic>> weightData;
  final Function(int) onItemTap;
  final bool isGeneratingPdf;
  final Function() onGeneratePdf;

  const WeightSummaryList({
    super.key,
    required this.weightData,
    required this.onItemTap,
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
                isExpanded: weightData[index]['isExpanded'] ?? false,
                onTap: () => onItemTap(index),
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
  final bool isExpanded;
  final VoidCallback onTap;

  const WeightEntryContainer({
    super.key,
    required this.data,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['date'],
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5AA189),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weight', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        Text(data['weight'].toString(), style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Unit', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        Text(data['unit'], style: TextStyle(fontSize: 14.sp)),
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