import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const SuccessDialog({Key? key, required this.onContinue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Success title
            Text(
              'Success!!',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Success message
            Text(
              'Your feedback added Successfully!',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Green checkmark
            Container(
              width: screenWidth * 0.15,
              height: screenWidth * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Continue button
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenHeight * 0.015,
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}