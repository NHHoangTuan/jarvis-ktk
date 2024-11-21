import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/common_widgets.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import 'edit_public_prompt_content.dart';

class EditPublicPrompt extends StatelessWidget {
  final PublicPrompt prompt;

  const EditPublicPrompt({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      contentPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0),
      actionsPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 16),
      title: EditPublicPromptTitle(
        prompt: prompt.title,
      ),
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          child: EditPublicPromptContent(prompt: prompt),
        ),
      ),
      actions: [
        SaveButton(onPressed: () {
          // Handle "Use Prompt" action
          try {
            getIt<PromptApi>().updatePrompt(prompt.id!, prompt);
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update prompt'),
              ),
            );
          }
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: 'Prompt updated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.8),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }),
      ],
      insetPadding: const EdgeInsets.all(10),
    );
  }
}

void showEditPublicPromptDialog(BuildContext context, PublicPrompt prompt) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditPublicPrompt(prompt: prompt);
    },
  );
}
