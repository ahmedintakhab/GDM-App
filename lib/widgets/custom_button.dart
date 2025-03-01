// custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? buttonColor;
  final double? borderRadius;
  final Color? textColor;
  final String buttonText;
  final bool loading;

  const CustomButton({
    Key? key,
    required this.onTap,
    this.buttonColor,
    this.borderRadius,
    required this.buttonText,
    this.textColor,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          color: buttonColor ?? const Color(0xFF5AA189),
        ),
        child: Center(
          child: loading ? CircularProgressIndicator(strokeWidth: 3,color: Colors.white,): Text(
            buttonText,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}