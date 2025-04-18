// stats_row_widget.dart

import 'package:flutter/material.dart';
import 'package:gdm_app/Home/step_count_container.dart';

class ProgressAndStepscount extends StatelessWidget {
  const ProgressAndStepscount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Container (Eaten Progress)
        // Expanded(
        //   flex: 3,
        //   child: Container(
        //     height: 120,
        //     padding: EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(12),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.05),
        //           blurRadius: 8,
        //         ),
        //       ],
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         SizedBox(
        //           width: 60,
        //           height: 60,
        //           child: Stack(
        //             fit: StackFit.expand,
        //             children: [
        //               CircularProgressIndicator(
        //                 value: 0.55,
        //                 strokeWidth: 10,
        //                 backgroundColor: Colors.grey[200],
        //                 valueColor: AlwaysStoppedAnimation<Color>(
        //                   Color(0xFF5AA189),
        //                 ),
        //               ),
        //               Center(
        //                 child: Text(
        //                   '55%',
        //                   style: TextStyle(
        //                     fontSize: 20,
        //                     fontWeight: FontWeight.bold,
        //                     color: Color(0xFF5AA189),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         SizedBox(width: 20),
        //         Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               'Eaten',
        //               style: TextStyle(
        //                 color: Color(0xFF5AA189),
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             SizedBox(height: 4),
        //             Text(
        //               '48 GL of 64 GL',
        //               style: TextStyle(
        //                 fontSize: 13,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.black,
        //               ),
        //             ),
        //             SizedBox(height: 4),
        //             Text(
        //               '32 GL is left',
        //               style: TextStyle(
        //                 color: Colors.grey[600],
        //                 fontSize: 12,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // SizedBox(width: 12), // Spacing between containers

        // Right Container (Steps Count)
        StepsCountContainer()
      
      ],
    );
  }
}