import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'delete_reminder_dialog.dart';

class ReminderItem extends StatefulWidget {
  final String time;
  final String frequency;
  final String type; // Line ~10: Added type parameter
  final bool isActive;
  final VoidCallback onDelete;
  final Function(bool) onToggle;

  const ReminderItem({
    Key? key,
    required this.time,
    required this.frequency,
    required this.type, // Line ~20: Added type
    required this.isActive,
    required this.onDelete,
    required this.onToggle,
  }) : super(key: key);

  @override
  _ReminderItemState createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => DeleteReminderDialog(
        onDelete: () {
          Navigator.pop(context);
          widget.onDelete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF2F8FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Time, Type, and Frequency
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.type, // Line ~60: Added type display
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(children: [
                  Text(
                    widget.frequency,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    widget.time,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                ],

                )

              ],
            ),
          ),

          // Toggle Switch
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
              widget.onToggle(value);
            },
            activeColor: Color(0xFF5AA189),
          ),

          // Delete Button
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[700]),
            onPressed: _showDeleteDialog,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }
}