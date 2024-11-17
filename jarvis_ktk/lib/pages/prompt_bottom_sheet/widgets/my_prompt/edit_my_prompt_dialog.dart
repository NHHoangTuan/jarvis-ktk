import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';

import '../common_widgets.dart';
import 'edit_my_prompt_content.dart';

class EditMyPrompt extends StatelessWidget {
  final MyPrompt prompt;

  const EditMyPrompt({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      contentPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0),
      actionsPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 16),
      title: EditMyPromptTitle(
        prompt: prompt.title,
      ),
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          child: EditMyPromptContent(prompt: prompt),
        ),
      ),
      actions: [
        SaveButton(onPressed: () {
          // Handle "Use Prompt" action
          Navigator.of(context).pop();
        }),
      ],
      insetPadding: const EdgeInsets.all(10),
    );
  }
}

void showEditPromptDialog(BuildContext context, MyPrompt prompt) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditMyPrompt(prompt: prompt);
    },
  );
}
