import 'package:flutter/material.dart';

class DevelopPreviewBotPage extends StatelessWidget {
  final TextEditingController controller;

  const DevelopPreviewBotPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Persona & Prompt'),
            SizedBox(
                width: 8.0), // Add some space between the text and the icon
            Icon(Icons.check_circle),
          ],
        ),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller, // Sử dụng controller
              maxLines: null, // Allow unlimited lines
              decoration: const InputDecoration(
                hintText:
                    'Design the bot\'s persona, features and workflows using natural language',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: InputBorder.none, // Remove the underline
              ),
            ),
          ),
        ],
      ),
    );
  }
}
