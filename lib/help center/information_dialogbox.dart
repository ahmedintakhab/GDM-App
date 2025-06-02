import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class InformationDialogbox extends StatelessWidget {
  final String title;
  final String description;

  const InformationDialogbox({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        constraints: BoxConstraints(
          maxHeight: 400.h, // Limit dialog height
          minWidth: 300.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            // Scrollable Description
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Fixed Continue Button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
                ),
                child: Text(
                  l10n.continueButton,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}