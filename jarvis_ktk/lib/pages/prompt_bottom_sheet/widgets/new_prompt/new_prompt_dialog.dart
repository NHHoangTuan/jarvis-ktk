import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/my_prompt/my_prompt_content.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/new_prompt/new_prompt_content.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_content.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import '../common_widgets.dart';

class NewPromptDialog extends StatefulWidget {
  final GlobalKey<MyPromptContentState> myPromptKey;
  final GlobalKey<PublicPromptContentState> publicPromptKey;

  const NewPromptDialog(
      {super.key, required this.myPromptKey, required this.publicPromptKey});

  @override
  State<NewPromptDialog> createState() => _NewPromptDialogState();
}
class _NewPromptDialogState extends State<NewPromptDialog> {
  bool _isLoading = false;

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
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: NewPromptDialogContent(onSave: (prompt) {
                currentPrompt = prompt;
              }),
            ),
            if (_isLoading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
      insetPadding: const EdgeInsets.all(10),
      actions: [
        const CancelButton(),
        SaveButton(onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          try {
            await getIt<PromptApi>().createPrompt(currentPrompt!);
            widget.myPromptKey.currentState?.refreshPrompts();
            if (currentPrompt! is PublicPrompt) {
              widget.publicPromptKey.currentState?.refreshPrompts();
            }
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                content: Text("Failed to create prompt"),
              ),
            );
          }
          Navigator.of(context).pop();
          setState(() {
            _isLoading = false;
          });
        }),
      ],
    );
  }
}

void showNewPromptDialog(
    BuildContext context,
    GlobalKey<MyPromptContentState> myPromptKey,
    GlobalKey<PublicPromptContentState> publicPromptKey) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return NewPromptDialog(
          myPromptKey: myPromptKey, publicPromptKey: publicPromptKey);
    },
  );
}
