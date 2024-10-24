import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isBot;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isBot,
  });

  @override
  Widget build(BuildContext context) {
    return isBot ? BotMessage(message: message) : UserMessage(message: message);
  }
}

class BotMessage extends StatelessWidget {
  final String message;

  const BotMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        margin: const EdgeInsets.only(top: 5.0),
        padding: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 0.7,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Jarvis reply",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: SimpleColors.royalBlue,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300]!,
              thickness: 0.7,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300]!,
              thickness: 0.7,
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
              child: Row(
                children: [
                  SizedBox(
                    height: 25,
                    width: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor:
                        SimpleColors.babyBlue.withOpacity(0.15),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Insert",
                        style: TextStyle(
                          fontSize: 12, // Text size
                          color: SimpleColors.royalBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Transform.flip(
                    flipX: true,
                    child: SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.copy,
                            color: Colors.grey, size: 16),
                      ),
                    ),
                  ),
                  Transform.flip(
                    flipX: true,
                    child: SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.replay,
                            color: Colors.grey, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserMessage extends StatelessWidget {
  final String message;

  const UserMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.7),
      // 16 + border width from UserMessage
      child: Container(
        margin: const EdgeInsets.only(top: 5.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: SimpleColors.babyBlue.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Received email",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}