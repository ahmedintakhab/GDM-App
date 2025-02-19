import 'package:flutter/material.dart';

class ChatContainer extends StatelessWidget {
  const ChatContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5AA189), // Background shaded color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline, // Chat icon on the right side
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Chat with Doctor', // First larger text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Personal AI assistant', // Second smaller text
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Row(
          //     children: const [
          //       Text(
          //         'Plus',
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 14,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       SizedBox(width: 4),
          //       Icon(
          //         Icons.add,
          //         color: Colors.black,
          //         size: 16,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
