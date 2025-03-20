import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'custom_text_form_field.dart';

class DropdownWidget extends StatefulWidget {
  final Function(String?) onChanged;
  final bool showDiabetesTestDate;
  final TextEditingController diabetesTestDateController;

  const DropdownWidget({
    Key? key,
    required this.onChanged,
    required this.showDiabetesTestDate,
    required this.diabetesTestDateController,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  final List<String> items = ['Yes', 'No', 'Not Sure'];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Did you have a test for diabetes during this pregnancy?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'Select Option',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: items
                .map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: selectedValue,
            onChanged: (String? value) {
              setState(() {
                selectedValue = value;
              });
              widget.onChanged(value); // Notify parent widget about the change
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                border: Border.all(
                  color: Colors.grey.shade400, // Border color
                  width: 1, // Border width
                ),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),        if (widget.showDiabetesTestDate) ...[
          SizedBox(height: 16),
          CustomTextFormField(
            controller: widget.diabetesTestDateController,
              hintText: 'When was the diabetes test done?',
            validator: (value) => value?.isEmpty ?? true ? 'Please enter test date' : null,
          ),
        ],
      ],
    );
  }
}