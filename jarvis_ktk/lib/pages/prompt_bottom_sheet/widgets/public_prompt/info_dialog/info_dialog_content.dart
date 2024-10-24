import 'package:flutter/material.dart';

import '../../../models/prompt.dart';

class InfoDialogContent extends StatelessWidget {
  const InfoDialogContent({super.key, required this.prompt});

  final PublicPrompt prompt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${prompt.category} - ${prompt.author}',
              style: const TextStyle(fontSize: 16)),
          if (prompt.description != null)
            Text(
              prompt.description!,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          const SizedBox(height: 8),
          const Text("Prompt",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          PromptTextBox(promptText: prompt.prompt),
        ],
      ),
    );
  }
}

class PromptTextBox extends StatelessWidget {
  const PromptTextBox({super.key, required this.promptText});

  final String promptText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 200,
        child: Scrollbar(
          radius: const Radius.circular(10),
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            child: Text(
              promptText,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}

class UsePromptButton extends StatelessWidget {
  const UsePromptButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: const Color(0xFF611FEC),
      ),
      icon: const Icon(Icons.chat_outlined, color: Colors.white, size: 20),
      onPressed: onPressed,
      label: const Text(
        'Use Prompt',
        style: TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class InfoDialogTitle extends StatelessWidget {
  const InfoDialogTitle({super.key, required this.prompt});

  final PublicPrompt prompt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          prompt.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton(
                icon: const Icon(Icons.star_border, size: 16),
                onPressed: () {
                  // Handle favorite button press
                },
              ),
            ),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
