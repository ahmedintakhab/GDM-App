import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_text_form_field.dart';

class DoctorVisitDialog extends StatefulWidget {
  final String? lastVisit;
  final String? nextVisit;

  const DoctorVisitDialog({
    Key? key,
    this.lastVisit,
    this.nextVisit,
  }) : super(key: key);

  @override
  _DoctorVisitDialogState createState() => _DoctorVisitDialogState();
}

class _DoctorVisitDialogState extends State<DoctorVisitDialog> {
  final _visitController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.nextVisit != null) {
      _visitController.text = widget.nextVisit!;
    }
  }

  @override
  void dispose() {
    _visitController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _visitController.text = DateFormat('dd MMM yyyy').format(picked);
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
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.updateDoctorVisits,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              CustomTextFormField(
                controller: _visitController,
                hintText: l10n.nextVisitDate,
                validator: (value) => value?.isEmpty ?? true ? l10n.pleaseEnterDate : null,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Color(0XFF5AA189),
                  onPressed: () => _selectDate(context),
                ),
              ),
              // TextFormField(
              //   controller: _visitController,
              //   decoration: InputDecoration(
              //     hintText: 'Next Visit Date',
              //     border: OutlineInputBorder(),
              //     suffixIcon: IconButton(
              //       icon: Icon(Icons.calendar_today),
              //       onPressed: () => _selectDate(context),
              //     ),
              //   ),
              //   readOnly: true,
              //   onTap: () => _selectDate(context),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select a date';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context, _visitController.text);
                        }
                      },
                      child: Text(l10n.submit,
                        style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF5AA189),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}