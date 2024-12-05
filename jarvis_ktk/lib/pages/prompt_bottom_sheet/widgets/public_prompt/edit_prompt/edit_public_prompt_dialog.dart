import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/common_widgets.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import 'edit_public_prompt_content.dart';

class EditPublicPrompt extends StatefulWidget {
  final PublicPrompt prompt;
  final Function(PublicPrompt) onUpdate;

  const EditPublicPrompt({super.key, required this.prompt, required this.onUpdate});

  @override
  State<EditPublicPrompt> createState() => _EditPublicPromptState();
}

class _EditPublicPromptState extends State<EditPublicPrompt> {
  bool _isLoading = false;

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
        prompt: widget.prompt.title,
      ),
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              EditPublicPromptContent(prompt: widget.prompt),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
      actions: [
        SaveButton(onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          try {
            await getIt<PromptApi>().updatePrompt(widget.prompt.id, widget.prompt);
            widget.onUpdate(widget.prompt);
            Fluttertoast.showToast(
              msg: 'Prompt updated',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.8),
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update prompt'),
              ),
            );
          } finally {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          }
        }),
      ],
      insetPadding: const EdgeInsets.all(10),
    );
  }
}

void showEditPublicPromptDialog(BuildContext context, PublicPrompt prompt, Function(PublicPrompt) onUpdate){
  final PublicPrompt promptCopy = PublicPrompt.fromJson(prompt.toJson());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditPublicPrompt(prompt: promptCopy, onUpdate: onUpdate);
    },
  );
}