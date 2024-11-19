import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/prompt_list.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_search_bar.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import 'filter/filter_buttons.dart';

class PublicPromptContent extends StatefulWidget {
  const PublicPromptContent({super.key});

  @override
  State<PublicPromptContent> createState() => _PublicPromptContentState();
}

class _PublicPromptContentState extends State<PublicPromptContent> {
  late Future<List<Prompt>> _promptsFuture;

  @override
  void initState() {
    super.initState();
    _promptsFuture = getIt<PromptApi>().getPrompts(isPublic: true);
  }

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
          FutureBuilder<List<Prompt>>(
              future: _promptsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No prompts available'));
                } else {
                  return Expanded(
                    child: CombinedPromptList(
                      combinedPrompts: snapshot.data ?? [],
                      onDelete: () {
                        // Handle delete action
                      },
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
