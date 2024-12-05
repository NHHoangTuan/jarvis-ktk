import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_tile.dart';

import '../../../data/models/prompt.dart';
import 'my_prompt/my_prompt_tile.dart';

class PromptListTile extends StatelessWidget {
  final Prompt anyPrompt;
  final VoidCallback onDelete;
  final void Function(Prompt) onClick;

  const PromptListTile(
      {super.key,
      required this.anyPrompt,
      required this.onDelete,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        onClick(anyPrompt),
        Navigator.of(context).pop(),
      },
      child: Column(
        children: [
          if (anyPrompt is MyPrompt)
            MyPromptTile(prompt: anyPrompt as MyPrompt, onDelete: onDelete),
          if (anyPrompt is PublicPrompt)
            PublicPromptTile(
                prompt: anyPrompt as PublicPrompt,
                onDelete: onDelete,
                onClick: onClick,
            ),
        ],
      ),
    );
  }
}
