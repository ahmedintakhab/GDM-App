import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/Diabetes_type_screen.dart';
import '../reminder/reminder_service_implementation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/dropdown_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PregnancyRegistrationScreen extends StatefulWidget {
  final String selectedOption;
  final ReminderService reminderService;

  const PregnancyRegistrationScreen({Key? key, required this.selectedOption, required this.reminderService}): super (key: key);

  @override
  _PregnancyRegistrationScreenState createState() => _PregnancyRegistrationScreenState();
}

class _PregnancyRegistrationScreenState extends State<PregnancyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _lmpController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _diabetesTestDateController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ethnicityController = TextEditingController();
  final _familyHistoryController = TextEditingController();
  final _pregnanciesController = TextEditingController();
  final _deliveriesController = TextEditingController();
  final _miscarriagesController = TextEditingController();
  final _stillbirthsController = TextEditingController();
  final _childrenAliveController = TextEditingController();

  String? _diabetesTest;
  bool _showDiabetesTestDate = false;
  String phoneNumber = '';

// Due Date Calculation Method (Naegele's rule)
  String calculateDueDate(DateTime lmpDate) {
    // Add 280 days (40 weeks) to LMP date
    DateTime dueDate = lmpDate.add(Duration(days: 280));
    return "${dueDate.toLocal()}".split(' ')[0];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _lmpController.text = "${picked.toLocal()}".split(' ')[0];
        // Calculate and set due date
        _dueDateController.text = calculateDueDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.pregnancyRegistration,
          style: TextStyle(
            color: const Color(0xFF5AA189),
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                //LMP due date calculated using Naegele's rule
                // LMP Field
                CustomTextFormField(
                  controller: _lmpController,
                  hintText: l10n.lmpLabel,
                  readOnly: true,
                  validator: (value) => value?.isEmpty ?? true ? l10n.pleaseEnterLMP : null,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    color: Color(0XFF5AA189),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                SizedBox(height: 16.h),

                // Expected Due Date Field (read-only)
                CustomTextFormField(
                  controller: _dueDateController,
                  hintText: l10n.expectedDueDate,
                  readOnly: true,
                  validator: (value) => value?.isEmpty ?? true ? l10n.pleaseEnterLMPToCalculate : null,
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Color(0XFF5AA189),
                  ),
                ),

                SizedBox(height: 16.h),

                // Diabetes Test Dropdown
                DropdownWidget(
                  onChanged: (value) {
                    setState(() {
                      _diabetesTest = value;
                      _showDiabetesTestDate = value == 'Yes';
                    });
                  },
                  showDiabetesTestDate: _showDiabetesTestDate,
                  diabetesTestDateController: _diabetesTestDateController,
                  items: [l10n.yes, l10n.no, l10n.notSure], // Pass the items
                  label: l10n.diabetesTestDate, // Pass the label
                ),

                SizedBox(height: 16.h),
                // Other Fields
                CustomTextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.phone,
                  hintText: l10n.ageLabel,
                  validator: (value) =>  null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _weightController,
                  hintText: l10n.weightLabel,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>  null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _heightController,
                  hintText: l10n.heightLabel,
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _ethnicityController,
                  hintText: l10n.ethnicityLabel,
                  validator: (value) =>  null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _familyHistoryController,
                  hintText: l10n.familyHistoryDiabetes,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _pregnanciesController,
                  hintText: l10n.numberOfPregnancies,
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _deliveriesController,
                  hintText: l10n.numberOfDeliveries,
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _miscarriagesController,
                  hintText: l10n.numberOfMiscarriages,
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _stillbirthsController,
                  hintText: l10n.numberOfStillbirths,
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _childrenAliveController,
                  hintText: l10n.numberOfChildrenAlive,
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
    padding: const EdgeInsets.symmetric( vertical: 20),
    child: Row(
    children: [
    // Back Button
    Expanded(
    child: CustomButton(
    onTap: () {
    // Navigate back
    Navigator.pop(context);
    },
    buttonText: l10n.back,
    ),
    ),
    // Next Button
    Expanded(
    child: CustomButton(
    onTap: () {
      if(_formKey.currentState!.validate()) {
        Map<String, dynamic> pregnancyData = {
          'lmp': _lmpController.text,
          'lmp dueDate': _dueDateController.text,
          'selectedOption': widget.selectedOption,
          'diabetesTest': _diabetesTest,
          'diabetesTestDate': _diabetesTestDateController.text,
          'age': _ageController.text,
          'weight': _weightController.text,
          'height': _heightController.text,
          'ethnicity': _ethnicityController.text,
          'familyHistory': _familyHistoryController.text,
          'pregnancies': _pregnanciesController.text,
          'deliveries': _deliveriesController.text,
          'miscarriages': _miscarriagesController.text,
          'stillbirths': _stillbirthsController.text,
          'childrenAlive': _childrenAliveController.text,
        };
        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              DiabetesTypeScreen(pregnancyData : pregnancyData,
                  reminderService: widget.reminderService)),
        );
      }
    },
    buttonText: l10n.next,
    ),
    ),
    ],
    ),
    ),
    );
  }
}