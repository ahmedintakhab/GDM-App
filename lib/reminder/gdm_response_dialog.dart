//Dialog for showing lmp notification
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/reminder/reminder_service_implementation.dart';
import 'package:provider/provider.dart';
import '../Home/user_data_provider.dart';
import '../l10n/app_localizations.dart';


class GdmResponseDialog extends StatelessWidget {
  final String reminderId;
  final ReminderService reminderService;

  const GdmResponseDialog({
    Key? key,
    required this.reminderId,
    required this.reminderService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        l10n.gdmTestReminder,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      content: Text(
        l10n.gdmTestReminderMessage,
        style: TextStyle(fontSize: 16.sp),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // Show snooze options
            final snoozeDuration = await showDialog<String>(
              context: context,
              builder: (context) => SimpleDialog(
                title: Text(l10n.snoozeReminder, style: TextStyle(fontSize: 16.sp)),
                children: [
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, '3days'),
                    child: Text(l10n.snoozeFor3Days, style: TextStyle(fontSize: 14.sp)),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, '1week'),
                    child: Text(l10n.snoozeFor1Week, style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            );

            if (snoozeDuration != null) {
             // await reminderService.handleGdmReminderResponse(reminderId, 'snooze', snoozeDuration: snoozeDuration);
              Navigator.pop(context);
            }
          },
          child: Text(l10n.thanksForReminder, style: TextStyle(fontSize: 14.sp)),
        ),
        TextButton(
          onPressed: () async {
            await reminderService.handleGdmReminderResponse(reminderId, 'done');
            await Provider.of<UserProvider>(context, listen: false).updateGdmTestStatus(true);
            Navigator.pop(context);
          },
          child: Text(l10n.iHaveDoneIt, style: TextStyle(fontSize: 14.sp, color: Colors.green)),
        ),
      ],
    );
  }
}