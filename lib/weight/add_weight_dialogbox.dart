import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import 'package:gdm_app/widgets/custom_button.dart';
import 'package:gdm_app/utils/utils.dart';
import 'package:gdm_app/Register/weight_input_field.dart';

class AddWeightDialogBox extends StatefulWidget {
  const AddWeightDialogBox({super.key});

  @override
  State<AddWeightDialogBox> createState() => _AddWeightDialogBoxState();
}

class _AddWeightDialogBoxState extends State<AddWeightDialogBox> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final ValueNotifier<String> _selectedUnit = ValueNotifier<String>('kg');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _dateController.dispose();
    _weightController.dispose();
    _selectedUnit.dispose();
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
        _dateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _addWeight() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        if (_dateController.text.isEmpty || _weightController.text.isEmpty) {
          Utils().toastMessage('Please enter both date and weight');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Check if a weight entry exists for the selected date
        QuerySnapshot existingEntry = await _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('weight')
            .where('date', isEqualTo: _dateController.text)
            .get();

        if (existingEntry.docs.isNotEmpty) {
          // Update existing entry
          String docId = existingEntry.docs.first.id;
          await _firestore
              .collection('Users')
              .doc(user.uid)
              .collection('weight')
              .doc(docId)
              .update({
            'weight': _weightController.text,
            'unit': _selectedUnit.value,
            'timestamp': FieldValue.serverTimestamp(),
          });
          Utils().toastMessage('Weight data successfully updated!');
        } else {
          // Create new entry
          await _firestore
              .collection('Users')
              .doc(user.uid)
              .collection('weight')
              .doc()
              .set({
            'date': _dateController.text,
            'weight': _weightController.text,
            'unit': _selectedUnit.value,
            'timestamp': FieldValue.serverTimestamp(),
          });
          Utils().toastMessage('Weight data successfully added!');
        }

        _dateController.clear();
        _weightController.clear();
        Navigator.of(context).pop(); // Close the dialog after success
      }
    } catch (e) {
      Utils().toastMessage('Error adding weight: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Weight'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              controller: _dateController,
              hintText: 'Pick Date',
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter date' : null,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                color: const Color(0XFF5AA189),
                onPressed: () => _selectDate(context),
              ),
            ),
            const SizedBox(height: 16),
            WeightInputField(
              weightController: _weightController,
              selectedUnit: _selectedUnit,
            ),
            const SizedBox(height: 36),
            Stack(
              alignment: Alignment.center,
              children: [
                CustomButton(
                  onTap: _isLoading ? () {} : () => _addWeight(),
                  buttonText: _isLoading ? '' : 'Add Weight',
                ),
                if (_isLoading)
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}