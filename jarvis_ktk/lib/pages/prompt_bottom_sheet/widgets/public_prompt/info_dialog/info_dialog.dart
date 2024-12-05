import 'package:flutter/material.dart';

import '../../../../../data/models/prompt.dart';
import 'info_dialog_content.dart';

class InfoDialog extends StatelessWidget {
  final void Function(PublicPrompt) onUsePrompt;

  const InfoDialog({super.key, required this.prompt, required this.onUsePrompt});

  final PublicPrompt prompt;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding:
          const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 0),
      contentPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0),
      actionsPadding:
          const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 16),
      title: InfoDialogTitle(prompt: prompt),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: InfoDialogContent(prompt: prompt),
      ),
      insetPadding: const EdgeInsets.all(10),

      actions: [
        UsePromptButton(onPressed: () {
          onUsePrompt(prompt);
          Navigator.of(context)..pop()..pop();
        }),
      ],
    );
  }
}

void showInfoDialog(BuildContext context, PublicPrompt prompt, void Function(PublicPrompt) onUsePrompt){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return InfoDialog(prompt: prompt, onUsePrompt: onUsePrompt);
    },
  );
}
