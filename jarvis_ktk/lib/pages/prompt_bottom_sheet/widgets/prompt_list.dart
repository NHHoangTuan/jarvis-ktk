import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_tile.dart';

import '../models/prompt.dart';
import 'my_prompt/my_prompt_tile.dart';


class CombinedPromptList extends StatelessWidget {
  final List<dynamic> combinedPrompts;

  const CombinedPromptList({super.key, required this.combinedPrompts});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: combinedPrompts.length,
      itemBuilder: (context, index) {
        final item = combinedPrompts[index];
        if (item is MyPrompt) {
          return MyPromptTile(prompt: item);
        } else if (item is PublicPrompt) {
          return PublicPromptTile(prompt: item);
        }
        return const SizedBox();
      },
      separatorBuilder: (context, index) => const Divider(indent: 16.0, endIndent: 16.0),
    );
  }
}
