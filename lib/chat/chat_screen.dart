import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdm_app/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;
import '../l10n/app_localizations.dart';
import 'chat_provider.dart';

class ChatGPTScreen extends StatefulWidget {
  @override
  _ChatGPTScreenState createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textEditingController = TextEditingController();
  bool _isLoading = false; // Flag to track loading state

  void onSendMessage() async {
    final l10n = AppLocalizations.of(context)!;
    String userMessage = _textEditingController.text.trim();
    if (userMessage.isEmpty) {
      // Don't send empty messages
      return;
    }

    Message message = Message(text: userMessage, isMe: true);
    _textEditingController.clear();

    setState(() {
      _messages.insert(0, message);
      _isLoading = true; // Start loading
    });
    // Add a loading message that will be replaced with the actual response
    Message loadingMessage = Message(text: l10n.loading, isMe: false, isLoading: true);
    setState(() {
      _messages.insert(0, loadingMessage);
    });

    try {
      String response = await sendMessageToGemini(message.text);

      setState(() {
        // Remove the loading message
        _messages.removeAt(0);
        // Add the actual response
        _messages.insert(0, Message(text: response, isMe: false));
        _isLoading = false; // End loading
      });
    } catch (e) {
      // Handle errors and show a message to the user
      setState(() {
        // Remove the loading message
        _messages.removeAt(0);
        // Add an error message
        _messages.insert(0, Message(text: "Error: Failed to get response", isMe: false));
        _isLoading = false; // End loading
      });

      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.failedToGetResponse}$e')),
      );
    }
  }

  Future<String> sendMessageToGemini(String message) async {
    Uri uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${APIKey.apiKey}');

    Map<String, dynamic> body = {
      'contents': [
        {
          'parts': [
            {'text': message}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 500,
      },
    };

    print('Sending request to Gemini API...');
    print('Request body: ${json.encode(body)}');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    print('API Response Status Code: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode != 200) {
      Map<String, dynamic> errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['error']['message'] ?? 'Unknown error';
      throw Exception('API Error: $errorMessage');
    }

    Map<String, dynamic> parsedResponse = json.decode(response.body);

    if (parsedResponse['candidates'] == null || parsedResponse['candidates'].isEmpty) {
      throw Exception('Invalid response format: No candidates found');
    }

    String reply = parsedResponse['candidates'][0]['content']['parts'][0]['text'];
    return reply;
  }

  Widget _buildMessage(Message message) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment:
          message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.isMe ? l10n.you : l10n.gdmAI,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            message.isLoading
                ? _buildLoadingIndicator()
                : Text(message.text),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5AA189)),
          ),
        ),
        SizedBox(width: 8),
        Text(l10n.typing, style: TextStyle(fontStyle: FontStyle.italic)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5AA189),
        title: Text(
          l10n.gdmAssistantChat,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomTextFormField(
              controller: _textEditingController,
              hintText: l10n.typeMessage,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterQuestion;
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(Icons.send, color: Color(0xFF5AA189)),
                onPressed: onSendMessage,
              ),
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
  final bool isLoading;

  Message({required this.text, required this.isMe, this.isLoading = false});
}