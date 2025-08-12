import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:gdm_app/utils/utils.dart';
import '../l10n/app_localizations.dart';

import '../dialogbox/doctor_visit_dialogbox.dart';

class DoctorVisitContainer extends StatefulWidget {
  const DoctorVisitContainer({Key? key}) : super(key: key);

  @override
  State<DoctorVisitContainer> createState() => _DoctorVisitContainerState();
}

class _DoctorVisitContainerState extends State<DoctorVisitContainer> {
  @override
  void initState() {
    super.initState();
    // Load visits when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.fetchDoctorVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => _showVisitDialog(context, provider),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.doctorCheckUp,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.local_hospital,
                      color: Colors.blue,
                      size: 24.sp,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.lastVisit,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          provider.lastVisit?.isNotEmpty == true
                              ? provider.lastVisit!
                              : l10n.notAvailable,
                          style: TextStyle(
                            color: provider.lastVisit?.isNotEmpty == true
                                ? Colors.grey
                                : Colors.grey[400],
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.nextVisit,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          provider.nextVisit?.isNotEmpty == true
                              ? provider.nextVisit!
                              : l10n.notScheduled,
                          style: TextStyle(
                            color: provider.nextVisit?.isNotEmpty == true
                                ? Colors.grey
                                : Colors.grey[400],
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showVisitDialog(BuildContext context, UserProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => DoctorVisitDialog(
        lastVisit: provider.lastVisit,
        nextVisit: provider.nextVisit,
      ),
    );

    if (result != null) {
      try {
        await provider.updateDoctorVisits(result);
        Utils().toastMessage(l10n.nextVisitUpdated);
      } catch (e) {
        Utils().toastMessage(l10n.failedToUpdateNextVisit);
      }
    }
  }
}