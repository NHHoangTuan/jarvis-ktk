import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/prompt_list.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_search_bar.dart';

import 'data/prompt_mock_data.dart';
import 'filter/filter_buttons.dart';

class PublicPromptContent extends StatelessWidget {
  const PublicPromptContent({super.key});

  @override
  Widget build(BuildContext context) {

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
            child: CombinedPromptList(combinedPrompts: publicPrompts),
          ),
        ],
      ),
    );
  }
}
