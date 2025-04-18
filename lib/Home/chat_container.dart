import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../chat/chat_screen.dart'; // Adjust import path as needed

class ChatActionButton extends StatelessWidget {
  const ChatActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF5AA189), // Button color
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ChatGPTScreen()),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat, color: Colors.white),
          SizedBox(height: 2.h),
          Text(
            'GDM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:gdm_app/chat/chat_screen.dart';
//
// class ChatContainer extends StatelessWidget {
//   const ChatContainer({Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: (){
//         Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatGPTScreen()));
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFF5AA189), // Background shaded color
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 const Icon(
//                   Icons.chat_bubble_outline, // Chat icon on the right side
//                   color: Colors.white,
//                   size: 28,
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'Chat with GDM Assistant', // First larger text
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Personal GDM assistant', // Second smaller text
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
