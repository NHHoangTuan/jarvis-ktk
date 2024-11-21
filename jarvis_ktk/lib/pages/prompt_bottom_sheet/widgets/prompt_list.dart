import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_tile.dart';

import '../../../data/models/prompt.dart';
import 'my_prompt/my_prompt_tile.dart';

class PromptListTile extends StatelessWidget {
  final Prompt anyPrompt;
  final VoidCallback onDelete;

  const PromptListTile({super.key, required this.anyPrompt, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (anyPrompt is MyPrompt)
          MyPromptTile(prompt: anyPrompt as MyPrompt, onDelete: onDelete),
        if (anyPrompt is PublicPrompt)
          PublicPromptTile(prompt: anyPrompt as PublicPrompt, onDelete: onDelete),
      ],
    );
  }
}