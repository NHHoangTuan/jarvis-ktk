import 'package:flutter/material.dart';

import '../../models/prompt.dart';

class MyPromptTile extends StatelessWidget {
  final MyPrompt prompt;

  const MyPromptTile({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(prompt.name),
      trailing: Container(
        padding: const EdgeInsets.all(0.0),
        width: 30.0,
        height: 30.0,
        child: IconButton(
          icon: const Icon(Icons.edit_note, size: 15),
          onPressed: () {
            // Handle edit button press
          },
        ),
      ),
    );
  }
}
