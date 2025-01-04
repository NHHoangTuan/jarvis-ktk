import 'package:flutter/material.dart';

class WelcomeBot extends StatelessWidget {
  const WelcomeBot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(Icons.android, size: 30),
          ),
          SizedBox(height: 10),
          Text(
            "Bot",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Start a conversation with the assistant by typing a message in the input box below",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
