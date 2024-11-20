import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/new_prompt/new_private_prompt_content.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/new_prompt/new_public_prompt_content.dart';
import '../tab_bar.dart';

class NewPromptDialogContent extends StatefulWidget {
  final Function(Prompt) onSave;

  const NewPromptDialogContent({super.key, required this.onSave});

  @override
  State<NewPromptDialogContent> createState() => _NewPromptDialogContentState();
}

class _NewPromptDialogContentState extends State<NewPromptDialogContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Prompt _prompt;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _updatePrompt(Prompt prompt) {
    setState(() {
      _prompt = prompt;
      widget.onSave(_prompt);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 485,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PromptTabBar(
              tabController: _tabController,
            ),
            SizedBox(
              height: 430,
              child: TabBarView(
                controller: _tabController,
                children: [
                  NewPrivatePromptContent(onPromptChanged: _updatePrompt),
                  NewPublicPromptContent(onPromptChanged: _updatePrompt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}