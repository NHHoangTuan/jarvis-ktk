import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;
  final VoidCallback onClearMessages;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSendMessage,
    required this.onClearMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.sms),
            onPressed: onClearMessages,
          ),
          Expanded(
            child: TextField(
              autofocus: false,
              controller: controller,
              maxLines: 4,
              minLines: 1,
              style: const TextStyle(fontSize: 14),
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                fillColor: SimpleColors.babyBlue.withOpacity(0.15),
                filled: true,
                hintText: "Tell Jarvis how you want to reply...",
                hintStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: SimpleColors.royalBlue),
            onPressed: onSendMessage,
          ),
        ],
      ),
    );
  }
}