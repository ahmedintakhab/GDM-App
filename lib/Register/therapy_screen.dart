// import 'package:flutter/material.dart';
// import 'package:gdm_app/Register/measurement_units.dart';
// import 'package:gdm_app/Register/progress_bar.dart';
// import 'package:gdm_app/Register/therapyoption_widget.dart';
// import '../widgets/custom_button.dart';
//
// class TherapyScreen extends StatefulWidget {
//   const TherapyScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TherapyScreen> createState() => _TherapyScreenState();
// }
//
// class _TherapyScreenState extends State<TherapyScreen> {
//   bool isInsulinSelected = false;
//   bool isPillsSelected = false;
//   TextEditingController insulinController = TextEditingController();
//   TextEditingController pillsController = TextEditingController();
//
//   @override
//   void dispose() {
//     insulinController.dispose();
//     pillsController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             const ProgressBar(currentStep: 3, totalSteps: 6),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//               child: const Text(
//                 'What is your therapy?',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//               child: const Text(
//                 'You can choose multiple options.',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 14),
//             TherapyOption(
//               title: 'Insulin',
//               question: 'What amount of short-acting insulin do you take a day?',
//               unit: 'mg/dl',
//               controller: insulinController,
//               isSelected: isInsulinSelected,
//               onSelected: (value) {
//                 setState(() {
//                   isInsulinSelected = value;
//                 });
//               },
//             ),
//             TherapyOption(
//               title: 'Pills',
//               question: 'How many pills do you take a day?',
//               unit: 'pills',
//               controller: pillsController,
//               isSelected: isPillsSelected,
//               onSelected: (value) {
//                 setState(() {
//                   isPillsSelected = value;
//                 });
//               },
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 0),
//               child: CustomButton(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MeasurementUnitsScreen()),
//                   );
//                 },
//                 buttonText: 'Next',
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }