import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/prompt_list.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_search_bar.dart';

import '../../models/prompt.dart';
import 'filter/filter_buttons.dart';

class PublicPromptContent extends StatelessWidget {
  const PublicPromptContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> combinedPrompts = [
      PublicPrompt(
        category: 'Category 1',
        description:
            'Improve your spelling and grammar by correcting errors in your writing.',
        language: 'English',
        name: 'Grammar corrector',
        prompt: '',
      ),
      PublicPrompt(
        category: 'Category 2',
        description:
            'Teach you the code with the most understandable knowledge.',
        language: 'English',
        name: 'Learn Code Fast',
        prompt: '',
      ),
      PublicPrompt(
        category: 'Category 3',
        description:
            'Improve your spelling and grammar by correcting errors in your writing.',
        language: 'English',
        name: 'Grammar corrector',
        prompt: '',
      ),
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
