import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/resized_image.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String avatar;
  final bool isLoading;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.avatar,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ResizedImage(imagePath: avatar, width: 32, height: 32, isRound: true),
          const SizedBox(height: 8),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: LoadingAnimationWidget.waveDots(
                color: Colors.blueGrey,
                size: 20,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.black : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: isUser ? Colors.grey : Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
