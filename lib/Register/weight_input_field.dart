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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for Radio Buttons with same padding as TextFormField
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                Transform.translate(
                  offset: const Offset(-12, 0), // Adjust radio button position
                  child: Radio(
                    value: 'kg',
                    groupValue: _selectedUnit,
                    onChanged: (value) {
                      setState(() {
                        _selectedUnit = value.toString();
                      });
                    },
                  ),
                ),
                const Text('kg'),
                const SizedBox(width: 20),
                Transform.translate(
                  offset: const Offset(-12, 0), // Adjust radio button position
                  child: Radio(
                    value: 'lbs',
                    groupValue: _selectedUnit,
                    onChanged: (value) {
                      setState(() {
                        _selectedUnit = value.toString();
                      });
                    },
                  ),
                ),
                const Text('lbs'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Weight Input Field
          _buildWeightField(),
        ],
      ),
    );
  }

  Widget _buildWeightField() {
    return CustomTextFormField(
      controller: _weightController,
      keyboardType: TextInputType.phone,
      hintText: _selectedUnit == 'kg'
          ? 'Enter your weight in kg'
          : 'Enter your weight in lbs',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your weight';
        }
        return null;
      },
    );
  }
}