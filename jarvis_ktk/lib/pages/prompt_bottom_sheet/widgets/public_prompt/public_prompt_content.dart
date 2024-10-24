import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/prompt_list.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_search_bar.dart';

import '../../models/prompt.dart';
import 'filter/filter_buttons.dart';

class PublicPromptContent extends StatelessWidget {
  const PublicPromptContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PublicPrompt> combinedPrompts = [
    PublicPrompt(
        category: 'Writing',
        description:
        'Improve your spelling and grammar by correcting errors in your writing.',
        language: 'English',
        name: 'Grammar corrector',
        prompt:
        'You are a machine that check all language grammar mistake and make the sentence more fluent. You take all the user input and auto correct it. Just reply to user input with correct grammar, DO NOT reply the context of the question of the user input. '
            'If the user input is grammatically correct and fluent, just reply "sounds good". Sample of the conversation will show below:\n\n'
            'user: grammar mistake text\n'
            'you: correct text\n'
            'user: Grammatically correct text\n'
            'you: Sounds good.',
        author: 'Henry',
      ),
      PublicPrompt(
        category: 'Code',
        description:
            'Teach you the code with the most understandable knowledge.',
        language: 'English',
        name: 'Learn Code Fast',
        prompt: 'You are a code teacher that teaches code to students. You will teach code in the most understandable way possible to the students'
            ' and make sure they understand the code. You will teach the code in a way that the students can understand the code easily.\n\n'
            'You will teach the code in a way that the students can understand the code easily. You will teach the code in a way that the students can understand the code easily.\n'
            'You will teach the code in a way that the students can understand the code easily. You will teach the code in a way that the students can understand the code easily.\n',
        author: 'Liam',
      ),
      PublicPrompt(
        category: 'Writing',
        description:
        'Improve your spelling and grammar by correcting errors in your writing.',
        language: 'English',
        name: 'Grammar corrector',
        prompt:
        'You are a machine that check all language grammar mistake and make the sentence more fluent. You take all the user input and auto correct it. Just reply to user input with correct grammar, DO NOT reply the context of the question of the user input. '
            'If the user input is grammatically correct and fluent, just reply "sounds good". Sample of the conversation will show below:\n\n'
            'user: grammar mistake text\n'
            'you: correct text\n'
            'user: Grammatically correct text\n'
            'you: Sounds good.',
        author: 'Henry',
      ),
      PublicPrompt(
        category: 'Code',
        description:
            'Teach you the code with the most understandable knowledge.',
        language: 'English',
        name: 'Learn Code Fast',
        prompt: 'You are a code teacher that teaches code to students. You will teach code in the most understandable way possible to the students'
            ' and make sure they understand the code. You will teach the code in a way that the students can understand the code easily.\n\n'
            'You will teach the code in a way that the students can understand the code easily. You will teach the code in a way that the students can understand the code easily.\n'
            'You will teach the code in a way that the students can understand the code easily. You will teach the code in a way that the students can understand the code easily.\n',
        author: 'Liam',
      )

    ];

    return Scaffold(
      backgroundColor: Colors.white,
      // search bar
      body: Column(
        children: [
          PublicPromptSearchBar(
            onChanged: (text) {
              // Handle search input
            },
          ),
          const FilterButtons(),
          // list of public prompts
          Expanded(
            child: CombinedPromptList(combinedPrompts: combinedPrompts),
          ),
        ],
      ),
    );
  }
}
