import 'package:flutter/material.dart';

class DeleteReminderDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteReminderDialog({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Reminder',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(
        'Are you sure you want to delete?',
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
            'Cancel',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: onDelete,
          child: Text(
            'Delete',
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