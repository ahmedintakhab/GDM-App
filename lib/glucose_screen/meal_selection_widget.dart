import 'package:flutter/material.dart';

class MealSelection extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final String selectedMealOption;

  const MealSelection({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.selectedMealOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selectedMealOption == label ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: selectedMealOption == label
                ? Border.all(color: Colors.green, width: 1)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}