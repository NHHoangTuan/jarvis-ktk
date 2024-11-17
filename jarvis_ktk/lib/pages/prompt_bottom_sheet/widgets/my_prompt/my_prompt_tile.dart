import 'package:flutter/material.dart';

import '../../../../data/models/prompt.dart';
import 'edit_my_prompt_dialog.dart';

class MyPromptTile extends StatelessWidget {
  final MyPrompt prompt;

  const MyPromptTile({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ListTile title
              Text(
                prompt.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 32.0,
                    height: 32.0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 16),
                      onPressed: () {
                        showEditPromptDialog(context, prompt);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
