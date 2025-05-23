import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/Home/home_main_screen.dart';
import 'package:gdm_app/Home/user_data_provider.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import '../reminder/reminder_service_implementation.dart';
import '../utils/utils.dart';

class UpdateProfile extends StatefulWidget {
  final ReminderService reminderService;

  UpdateProfile({super.key, required this.reminderService});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _waistController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ethnicityController = TextEditingController();
  final _diabetesController = TextEditingController();
  final _deliveriesController = TextEditingController();
  final _childrenAliveController = TextEditingController();
  final _pregnanciesController = TextEditingController();
  final _diabetesTestDateController = TextEditingController();
  final _miscarriagesController = TextEditingController();
  final _stillbirthsController = TextEditingController();
  final _familyHistoryController = TextEditingController();
  final _hypertensionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ethnicityController.dispose();
    _genderController.dispose();
    _waistController.dispose();
    _diabetesController.dispose();
    _deliveriesController.dispose();
    _childrenAliveController.dispose();
    _pregnanciesController.dispose();
    _diabetesTestDateController.dispose();
    _miscarriagesController.dispose();
    _stillbirthsController.dispose();
    _familyHistoryController.dispose();
    _hypertensionController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile(BuildContext context, UserProvider userProvider) async {
    setState(() {
      _isUpdating = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator(color: Color(0XFF5AA189)));
      },
    );

    try {
      bool success = await userProvider.updateUserProfile(
        _nameController.text,
        _emailController.text,
        _ageController.text,
        _weightController.text,
        _heightController.text,
        _ethnicityController.text,
        gender: _genderController.text,
        waist: _waistController.text,
        diabetes: _diabetesController.text,
        hypertension: _hypertensionController.text,
        deliveries: _deliveriesController.text,
        childrenAlive: _childrenAliveController.text,
        pregnancies: _pregnanciesController.text,
        diabetesTestDate: _diabetesTestDateController.text,
        miscarriages: _miscarriagesController.text,
        stillbirths: _stillbirthsController.text,
        familyHistory: _familyHistoryController.text,
      );

      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        _isUpdating = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(reminderService: widget.reminderService)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${userProvider.errorMessage}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        _isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFF5AA189),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (!userProvider.isLoading && !_isUpdating) {
            _nameController.text = userProvider.name;
            _emailController.text = userProvider.email;
            _ageController.text = userProvider.age;
            _weightController.text = userProvider.weight;
            _heightController.text = userProvider.height;
            _ethnicityController.text = userProvider.ethnicity;
            _genderController.text = userProvider.gender;
            _waistController.text = userProvider.waist;
            _diabetesController.text = userProvider.diabetes;
            _deliveriesController.text = userProvider.deliveries;
            _childrenAliveController.text = userProvider.childrenAlive;
            _pregnanciesController.text = userProvider.pregnancies;
            _diabetesTestDateController.text = userProvider.diabetesTestDate;
            _miscarriagesController.text = userProvider.miscarriages;
            _stillbirthsController.text = userProvider.stillbirths;
            _familyHistoryController.text = userProvider.familyHistory;
            _hypertensionController.text = userProvider.hypertension;
          }
          return userProvider.isLoading && !_isUpdating
              ? Center(child: CircularProgressIndicator(color: Color(0XFF5AA189)))
              : SafeArea(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 60.r,
                            color: Colors.grey[600],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20.r,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: 'Name',
                      labelText: 'Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: 'Email',
                      labelText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    if (userProvider.userType != 'Doctor') ...[
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.phone,
                              hintText: 'Age',
                              labelText: 'Age',
                              validator: (value) => null,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: CustomTextFormField(
                              controller: _heightController,
                              hintText: 'Height (cm)',
                              labelText: 'Height',
                              keyboardType: TextInputType.phone,
                              validator: (value) => null,
                            ),
                          ),
                        ],
                      ),
                      if (userProvider.userType == 'Not Pregnant') ...[
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _genderController,
                                hintText: 'Male or Female',
                                labelText: 'Gender',
                                validator: (value) => null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _waistController,
                                hintText: 'Waist',
                                labelText: 'Waist',
                                keyboardType: TextInputType.phone,
                                validator: (value) => null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _hypertensionController,
                                hintText: 'Hypertension',
                                labelText: 'Hypertension',
                                validator: (value) => null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _diabetesController,
                                hintText: 'Diabetes',
                                labelText: 'Diabetes',
                                validator: (value) => null,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        controller: _ethnicityController,
                        hintText: 'Ethnicity',
                        labelText: 'Ethnicity',
                        validator: (value) => null,
                      ),
                      if (userProvider.userType == 'Pregnant') ...[
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _weightController,
                                hintText: 'Weight (kg)',
                                labelText: 'Weight',
                                keyboardType: TextInputType.phone,
                                validator: (value) => null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _pregnanciesController,
                                hintText: 'Pregnancies',
                                labelText: 'Pregnancies',
                                keyboardType: TextInputType.phone,
                                validator: (value) => null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        CustomTextFormField(
                          controller: _deliveriesController,
                          hintText: 'Previous Deliveries',
                          labelText: 'Previous Deliveries',
                          keyboardType: TextInputType.phone,
                          validator: (value) => null,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _familyHistoryController,
                                hintText: 'Family History',
                                labelText: 'Family History',
                                validator: (value) => null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _miscarriagesController,
                                hintText: 'Miscarriages',
                                labelText: 'Miscarriages',
                                keyboardType: TextInputType.phone,
                                validator: (value) => null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _stillbirthsController,
                                hintText: 'Still Births',
                                labelText: 'Still Births',
                                keyboardType: TextInputType.phone,
                                validator: (value) => null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _childrenAliveController,
                                hintText: 'Children Alive',
                                labelText: 'Children Alive',
                                keyboardType: TextInputType.phone,
                                validator: (value) => null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                    SizedBox(height: 30.h),
                    CustomButton(
                      onTap: () => _updateProfile(context, userProvider),
                      buttonText: 'Update Profile',
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}