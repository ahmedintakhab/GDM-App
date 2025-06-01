import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DueDateDialogBox extends StatefulWidget {
  final String initialDueDate;
  final String initialLmp;
  final Function(String, String)? onUpdate;

  const DueDateDialogBox({
    Key? key,
    required this.initialDueDate,
    required this.initialLmp,
    this.onUpdate,
  }) : super(key: key);

  @override
  _DueDateDialogBoxState createState() => _DueDateDialogBoxState();
}

class _DueDateDialogBoxState extends State<DueDateDialogBox> {
  final _lmpController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _lmpController.text = widget.initialLmp;
    _dueDateController.text = widget.initialDueDate;
  }

  @override
  void dispose() {
    _lmpController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  String calculateDueDate(DateTime lmpDate) {
    // Add 280 days (40 weeks) to LMP date
    DateTime dueDate = lmpDate.add(const Duration(days: 280));
    return "${dueDate.toLocal()}".split(' ')[0];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lmpController.text.isNotEmpty
          ? DateTime.parse(_lmpController.text)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() {
        _lmpController.text = "${picked.toLocal()}".split(' ')[0];
        _dueDateController.text = calculateDueDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          constraints: BoxConstraints(
            maxHeight: 450.h,
            minWidth: 300.w,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.setDueDate,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                // LMP Field
                TextFormField(
                  controller: _lmpController,
                  decoration: InputDecoration(
                    hintText: l10n.lmpLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today, size: 20.sp),
                      color: const Color(0XFF5AA189),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  validator: (value) =>
                  value?.isEmpty ?? true ? l10n.pleaseEnterLMP : null,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                SizedBox(height: 16.h),
                // Expected Due Date Field (read-only)
                TextFormField(
                  controller: _dueDateController,
                  decoration: InputDecoration(
                    hintText: l10n.dueDateLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: const Color(0XFF5AA189),
                      size: 20.sp,
                    ),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? l10n.pleaseEnterLMP
                      : null,
                  readOnly: true,
                ),
                SizedBox(height: 24.h),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            l10n.back,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF5AA189),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() && mounted) {
                              if (widget.onUpdate != null) {
                                widget.onUpdate!(
                                  _lmpController.text,
                                  _dueDateController.text,
                                );
                              }
                              Navigator.of(context).pop(true);
                            }
                          },
                          child: Text(
                            l10n.update,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}