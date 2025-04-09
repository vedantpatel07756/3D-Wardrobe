

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wardrope_app/Chat/geminiService.dart';
import 'package:wardrope_app/Config.dart';
import 'dart:io';
// import 'gemini_service.dart';
// import 'config.dart'; // Make sure to import your Config class

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadAndGetRecommendations(_imageFile!);
    }
  }

  Future<void> _uploadAndGetRecommendations(File imageFile) async {
    try {
      var uploadedFile = await GeminiService.uploadToGemini(imageFile, 'image/webp');
      var recommendations = await GeminiService.getRecommendations(uploadedFile['uri']);
      setState(() {
        _messages.add(ChatMessage(
          text: recommendations['text'], // Assuming response contains a 'text' field
          image: _imageFile,
        ));
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text,
        ));
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.backgroundColor,
  
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.text, style: TextStyle(color: Config.textColor)),
                  leading: message.image != null
                      ? Image.file(message.image!, width: 50, height: 50)
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Config.accentColor),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Config.textColor),
                    decoration: InputDecoration(
                      hintText: "Type the message",
                      hintStyle: TextStyle(color: Config.textColor.withOpacity(0.6)),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Config.secondaryColor.withOpacity(0.1),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Config.accentColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final File? image;

  ChatMessage({required this.text, this.image});
}
