import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';


class DeleteReminderDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteReminderDialog({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        l10n.deleteReminder,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(
        l10n.confirmDeleteReminder,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.cancel,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: onDelete,
          child: Text(
            l10n.delete,
            style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}