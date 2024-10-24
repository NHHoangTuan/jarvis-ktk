import 'package:flutter/material.dart';
import '../../../models/prompt.dart';
import 'info_dialog_content.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key, required this.prompt});

  final PublicPrompt prompt;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: InfoDialogTitle(prompt: prompt),
      content: InfoDialogContent(prompt: prompt),
      actions: [
        UsePromptButton(onPressed: () {
          // Handle "Use Prompt" action
        }),
      ],
    );
  }
}

void showInfoDialog(BuildContext context, PublicPrompt prompt) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return InfoDialog(prompt: prompt);
    },
  );
}
