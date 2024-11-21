import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/new_prompt/new_prompt_content.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import '../common_widgets.dart';

class NewPromptDialog extends StatelessWidget {
  const NewPromptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Prompt? currentPrompt;

    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      contentPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0),
      actionsPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 16),
      title: const NewPromptDialogTitle(),
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: NewPromptDialogContent(onSave: (prompt) {
            currentPrompt = prompt;
          }),
        ),
      ),
      insetPadding: const EdgeInsets.all(10),
      actions: [
        const CancelButton(),
        SaveButton(onPressed: () {
          try {
            getIt<PromptApi>().createPrompt(currentPrompt!);
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to create prompt'),
              ),
            );
          }
          Navigator.of(context).pop();
        }),
      ],
    );
  }
}

void showNewPromptDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const NewPromptDialog();
    },
  );
}
