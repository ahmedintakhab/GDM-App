import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/Diabetes_type_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/dropdown_widget.dart';

class PregnancyRegistrationScreen extends StatefulWidget {
  final String selectedOption;
  const PregnancyRegistrationScreen({Key? key, required this.selectedOption}): super (key: key);

  @override
  _PregnancyRegistrationScreenState createState() => _PregnancyRegistrationScreenState();
}

class _PregnancyRegistrationScreenState extends State<PregnancyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _lmpController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _diabetesTestDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pregnancy Registration',
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

                // LMP Field
                //LMP due date calculated using Naegele's rule
                // LMP Field
                CustomTextFormField(
                  controller: _lmpController,
                  hintText: 'Last Menstrual Period (LMP)',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter LMP' : null,
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
                  hintText: 'Expected Due Date (Read only)',
                  readOnly: true,
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter LMP to calculate' : null,
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
                  items: ['Yes', 'No', 'Not Sure'], // Pass the items
                  label: 'Did you have a test for diabetes during this pregnancy?', // Pass the label
                ),


                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'Enter your name',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter name' : null,
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter email' : null,
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                // Other Fields
                CustomTextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.phone,
                  hintText: 'Enter your age',
                  validator: (value) =>  null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _weightController,
                  hintText: ' Enter your weight (kg)',
                  keyboardType: TextInputType.phone,
                  validator: (value) =>  null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _heightController,
                  hintText: 'Enter your height (cm)',
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _ethnicityController,
                  hintText: 'Enter your ethnicity',
                  validator: (value) =>  null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _familyHistoryController,
                  hintText: 'Family History of Type 2 Diabetes',
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _pregnanciesController,
                  hintText: 'Number of Pregnancies',
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _deliveriesController,
                  hintText: 'Number of Previous Deliveries',
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _miscarriagesController,
                  hintText: 'Number of Miscarriages',
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _stillbirthsController,
                  hintText: 'Number of Stillbirths',
                  keyboardType: TextInputType.phone,
                  validator: (value) => null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _childrenAliveController,
                  hintText: 'Number of Children Alive',
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
    buttonText: 'Back',
    ),
    ),
    // Next Button
    Expanded(
    child: CustomButton(
    onTap: () {
      if(_formKey.currentState!.validate()) {
        Map<String, dynamic> pregnancyData = {
          'lmp': _lmpController.text,
          'dueDate': _dueDateController.text,
          'name': _nameController.text,
          'selectedOption': widget.selectedOption,
          'diabetesTest': _diabetesTest,
          'diabetesTestDate': _diabetesTestDateController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          // 'phone': phoneNumber,
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
          MaterialPageRoute(builder: (context) => DiabetesTypeScreen(pregnancyData : pregnancyData)),
        );
      }
    },
    buttonText: 'Next',
    ),
    ),
    ],
    ),
    ),
    );
  }
}