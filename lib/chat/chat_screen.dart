import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

import 'chat_provider.dart';

class ChatGPTScreen extends StatefulWidget {
  @override
  _ChatGPTScreenState createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textEditingController = TextEditingController();

  void onSendMessage() async {
    String userMessage = _textEditingController.text.trim();
    if (userMessage.isEmpty) {
      // Don't send empty messages
      return;
    }

    Message message = Message(text: userMessage, isMe: true);
    _textEditingController.clear();

    setState(() {
      _messages.insert(0, message);
    });

    try {
      String response = await sendMessageToDeepSeek(message.text);
      Message deepSeekResponse = Message(text: response, isMe: false);

      setState(() {
        _messages.insert(0, deepSeekResponse);
      });
    } catch (e) {
      // Handle errors and show a message to the user
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get response: $e')),
      );
    }
  }

  Future<String> sendMessageToDeepSeek(String message) async {
    // Replace with the actual DeepSeek API endpoint
    Uri uri = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    // Replace with the correct request body for DeepSeek API
    Map<String, dynamic> body = {
      "model": "deepseek/deepseek-r1", // Replace with the correct model name
      "messages": [
        {"role": "user", "content": message}
      ],
      "max_tokens": 500, // Adjust as needed
    };

    print('Sending request to DeepSeek API...');
    print('Request body: ${json.encode(body)}');

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${APIKey.apiKey}", // Use DeepSeek API key
      },
      body: json.encode(body),
    );

    print('API Response Status Code: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode != 200) {
      // Handle non-200 responses
      Map<String, dynamic> errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['error']?['message'] ?? 'Unknown error';
      throw Exception('API Error: $errorMessage');
    }

    Map<String, dynamic> parsedResponse = json.decode(response.body);

    // Check if the response contains the expected data
    if (parsedResponse['choices'] == null || parsedResponse['choices'].isEmpty) {
      throw Exception('Invalid response format: No choices found');
    }

    // Extract the response text (adjust based on DeepSeek API response structure)
    String reply = parsedResponse['choices'][0]['message']['content'];
    return reply;
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment:
          message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.isMe ? 'You' : 'DeepSeek',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(message.text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF5AA189),
        title: Text('DeepSeek Chat', style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          // Divider(height: 1.0),
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: CustomTextFormField(
          //     controller: _textEditingController,
          //     hintText: 'Type a message...',
          //     validator: (value) {
          //       if (value == null || value.trim().isEmpty) {
          //         return 'Please enter a question';
          //       }
          //       return null;
          //     },
          //      suffixIcon: IconButton(
          //                    icon: Icon(Icons.send, color: Color(0XFF5AA189)),
          //                   onPressed: onSendMessage,
          //                  ),
          //   ),
          // )
          Container(
            padding: EdgeInsets.all( 15.0), // Bottom padding
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
              // border: Border.all(color: Colors.grey.shade300, width: 1.5), // Border color & width
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    cursorColor: Color(0XFF5AA189), // Cursor color
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Type a message...',
                      border: OutlineInputBorder( // Border when enabled
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder( // Default border
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder( // Border when focused
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color(0XFF5AA189), width: 2.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: Color(0XFF5AA189)),
                        onPressed: onSendMessage,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )

        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}