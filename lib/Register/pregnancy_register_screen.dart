import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/Diabetes_type_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/intl_phone_field.dart';

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
  final _diabetesTestDateController = TextEditingController();
  final _emailController = TextEditingController();
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

                // Diabetes Test Radio Buttons
                Text(
                  'Did you have a test for diabetes during this pregnancy?',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _diabetesTest,
                      onChanged: (value) {
                        setState(() {
                          _diabetesTest = value;
                          _showDiabetesTestDate = value == 'Yes';
                        });
                      },
                      activeColor: const Color(0xFF5AA189),
                    ),
                    Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _diabetesTest,
                      onChanged: (value) {
                        setState(() {
                          _diabetesTest = value;
                          _showDiabetesTestDate = false;
                        });
                      },
                      activeColor: const Color(0xFF5AA189),
                    ),
                    Text('No'),
                    Radio<String>(
                      value: 'Not Sure',
                      groupValue: _diabetesTest,
                      onChanged: (value) {
                        setState(() {
                          _diabetesTest = value;
                          _showDiabetesTestDate = false;
                        });
                      },
                      activeColor: const Color(0xFF5AA189),
                    ),
                    Text('Not Sure'),
                  ],
                ),

                if (_showDiabetesTestDate) ...[
                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    controller: _diabetesTestDateController,
                    hintText: 'When was the diabetes test done?',
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter test date' : null,
                  ),
                ],

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
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter password' : null,
                ),
                SizedBox(height: 16.h),
                phone_number_field(
                  onPhoneNumberChanged: (String phone) {
                    setState(() {
                      phoneNumber = phone; // Store the phone number
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),


                // Other Fields
                CustomTextFormField(
                  controller: _ageController,
                  hintText: 'Enter your age',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter age' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _weightController,
                  hintText: ' Enter your weight (kg)',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter weight' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _heightController,
                  hintText: 'Enter your height (cm)',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter height' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _ethnicityController,
                  hintText: 'Enter your ethnicity',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter ethnicity' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _familyHistoryController,
                  hintText: 'Family History of Type 2 Diabetes',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter family history' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _pregnanciesController,
                  hintText: 'Number of Pregnancies',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter number of pregnancies' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _deliveriesController,
                  hintText: 'Number of Previous Deliveries',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter number of deliveries' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _miscarriagesController,
                  hintText: 'Number of Miscarriages',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter number of miscarriages' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _stillbirthsController,
                  hintText: 'Number of Stillbirths',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter number of stillbirths' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _childrenAliveController,
                  hintText: 'Number of Children Alive',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter number of children alive' : null,
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
          'selectedOption': widget.selectedOption,
          'lmp': _lmpController.text,
          'diabetesTest': _diabetesTest,
          'diabetesTestDate': _diabetesTestDateController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'phone': phoneNumber,
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