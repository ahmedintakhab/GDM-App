import 'package:flutter/material.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';

class WeightInputField extends StatefulWidget {
  const WeightInputField({super.key});

  @override
  State<WeightInputField> createState() => _WeightInputFieldState();
}

class _WeightInputFieldState extends State<WeightInputField> {
  final TextEditingController _weightController = TextEditingController();
  String _selectedUnit = 'kg'; // Default selected unit

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Radio Buttons for Unit Selection
        Row(
          children: [
            Radio(
              value: 'kg',
              groupValue: _selectedUnit,
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value.toString();
                });
              },
            ),
            const Text('kg'),
            Radio(
              value: 'lbs',
              groupValue: _selectedUnit,
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value.toString();
                });
              },
            ),
            const Text('lbs'),
          ],
        ),
        // Weight Input Field
        _buildWeightField(),
      ],
    );
  }

  Widget _buildWeightField() {
     return CustomTextFormField(
              controller: _weightController,
                hintText: _selectedUnit == 'kg'
                    ? 'Enter your weight in kg'
                    : 'Enter your weight in lbs',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your weight';
                }
                return null;
              }

    );
  }
}