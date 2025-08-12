import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:gdm_app/utils/utils.dart';
import '../dialogbox/due_date_dialogbox.dart';
import '../reminder/gdm_response_dialog.dart';
import '../reminder/reminder_service_implementation.dart';
import '../l10n/app_localizations.dart';


class LinearProgressContainer extends StatefulWidget {
  final ReminderService reminderService;

  const LinearProgressContainer({Key? key, required this.reminderService}) : super(key: key);

  @override
  State<LinearProgressContainer> createState() => _LinearProgressContainerState();
}

class _LinearProgressContainerState extends State<LinearProgressContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.fetchPregnancyInfo();

      // Set the callback for GDM reminder taps
      widget.reminderService.setGdmReminderTappedCallback(_showGdmResponseDialog);

      // Listen for GDM reminder taps when the app is opened from terminated/background state
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final reminderId = message.data['reminderId'];
        if (reminderId != null && reminderId.startsWith('gdm_')) {
          _showGdmResponseDialog(reminderId);
        }
      });

      // Handle initial message if the app was opened via notification
      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          final reminderId = message.data['reminderId'];
          if (reminderId != null && reminderId.startsWith('gdm_')) {
            _showGdmResponseDialog(reminderId);
          }
        }
      });
    });
  }

  void _openDueDateDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<UserProvider>(context, listen: false);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DueDateDialogBox(
        initialDueDate: provider.dueDate,
        initialLmp: provider.lmp,
        onUpdate: (newLmp, newDueDate) async {
          return await provider.updatePregnancyInfo(newLmp, newDueDate);
        },
      ),
    );

    if (result != null && mounted) {
      Utils().toastMessage(result ? l10n.dueDateUpdated : l10n.failedToUpdateDueDate);
    }
  }

  void _showGdmResponseDialog(String reminderId) {
    showDialog(
      context: context,
      builder: (context) => GdmResponseDialog(
        reminderId: reminderId,
        reminderService: widget.reminderService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final progressData = _calculateProgressAndWeeks(provider.lmp, provider.dueDate, l10n);

        return GestureDetector(
          onTap: () => _openDueDateDialog(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.expectedDueDate,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      progressData['weeksLeft'] ?? l10n.setDueDate,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: progressData['weeksLeft'] == l10n.dueDatePassed
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                LinearProgressIndicator(
                  value: progressData['progressValue'] ?? 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5AA189)),
                  minHeight: 10.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                SizedBox(height: 12.h),
                Text(
                  provider.dueDate.isNotEmpty ? provider.dueDate : l10n.noDueDateSet,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: provider.dueDate.isNotEmpty ? Colors.black54 : Colors.grey,
                  ),
                ),
                SizedBox(height: 12.h),
                if (!provider.gdmTestDone)
                  ElevatedButton(
                    onPressed: () async {
                      final success = await provider.updateGdmTestStatus(true);
                      if (success) {
                        Utils().toastMessage(l10n.gdmTestDone);
                      } else {
                        Utils().toastMessage(l10n.failedToMarkGdmTest);
                      }
                    },
                    child: Text(
                      l10n.markGdmTestDone,
                      style: TextStyle(fontSize: 14.sp, color: Color(0XFF5AA189)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _calculateProgressAndWeeks(String lmp, String dueDate,AppLocalizations l10n) {
    if (lmp.isEmpty || dueDate.isEmpty) {
      return {
        'progressValue': 0.0,
        'weeksLeft': l10n.setDueDate,
      };
    }

    try {
      final lmpDate = DateTime.parse(lmp);
      final dueDateTime = DateTime.parse(dueDate);
      final now = DateTime.now();

      final totalDays = dueDateTime.difference(lmpDate).inDays;
      final daysPassed = now.difference(lmpDate).inDays;
      double progressValue = daysPassed / totalDays;
      progressValue = progressValue.clamp(0.0, 1.0);

      final daysRemaining = dueDateTime.difference(now).inDays;
      final weeksRemaining = (daysRemaining / 7).ceil();

      String weeksLeft;
      if (daysRemaining < 0) {
        weeksLeft = l10n.dueDatePassed;
      } else if (weeksRemaining == 0) {
        weeksLeft = l10n.dueThisWeek;
      } else {
        weeksLeft = '$weeksRemaining week${weeksRemaining == 1 ? '' : 's'}${l10n.left}';
      }

      return {
        'progressValue': progressValue,
        'weeksLeft': weeksLeft,
      };
    } catch (e) {
      return {
        'progressValue': 0.0,
        'weeksLeft': l10n.invalidDate,
      };
    }
  }
}