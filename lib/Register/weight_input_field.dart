import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import '../l10n/app_localizations.dart';


class WeightInputField extends StatefulWidget {
  final TextEditingController weightController;
  final ValueNotifier<String> selectedUnit;

  const WeightInputField({
    super.key,
    required this.weightController,
    required this.selectedUnit,
  });

  @override
  State<WeightInputField> createState() => _WeightInputFieldState();
}

class _WeightInputFieldState extends State<WeightInputField> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weight Input Field
          _buildWeightField(),
          const SizedBox(height: 8),
          // Container for Radio Buttons with same padding as TextFormField
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: ValueListenableBuilder<String>(
              valueListenable: widget.selectedUnit,
              builder: (context, unit, child) {
                return Row(
                  children: [
                    Transform.translate(
                      offset: const Offset(-12, 0), // Adjust radio button position
                      child: Radio<String>(
                        value: l10n.kgUnit,
                        groupValue: unit,
                        onChanged: (value) {
                          if (value != null) {
                            widget.selectedUnit.value = value;
                          }
                        },
                      ),
                    ),
                     Text(l10n.kgUnit),
                    const SizedBox(width: 20),
                    Transform.translate(
                      offset: const Offset(-12, 0), // Adjust radio button position
                      child: Radio<String>(
                        value: l10n.lbsUnit,
                        groupValue: unit,
                        onChanged: (value) {
                          if (value != null) {
                            widget.selectedUnit.value = value;
                          }
                        },
                      ),
                    ),
                     Text(l10n.lbsUnit),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildWeightField() {
    final l10n = AppLocalizations.of(context)!;
    return ValueListenableBuilder<String>(
      valueListenable: widget.selectedUnit,
      builder: (context, unit, child) {
        return CustomTextFormField(
          controller: widget.weightController,
          keyboardType: TextInputType.number,
          hintText: unit == l10n.kgUnit ? l10n.weightInKg : l10n.weightInLbs,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterWeight;
            }
            return null;
          },
        );
      },
    );
  }
}