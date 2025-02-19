import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Register/Diabetes_type_screen.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_form_field.dart';

class PregnancyRegistrationScreen extends StatefulWidget {
  @override
  _PregnancyRegistrationScreenState createState() => _PregnancyRegistrationScreenState();
}

class _PregnancyRegistrationScreenState extends State<PregnancyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _lmpController = TextEditingController();
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

                // Other Fields
                CustomTextFormField(
                  controller: _ageController,
                  hintText: 'Age',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter age' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _weightController,
                  hintText: 'Weight (kg)',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter weight' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _heightController,
                  hintText: 'Height (cm)',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter height' : null,
                ),
                SizedBox(height: 16.h),

                CustomTextFormField(
                  controller: _ethnicityController,
                  hintText: 'Ethnicity',
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

                Padding(
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
                          // backgroundColor: Colors.grey, // Custom color for Back button
                        ),
                      ),
                      // const SizedBox(width: 6), // Spacing between buttons
                      // Next Button
                      Expanded(
                        child: CustomButton(
                          onTap: () {

                              // Navigate to the next screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DiabetesTypeScreen()),
                              );
                          },
                          buttonText: 'Next',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}