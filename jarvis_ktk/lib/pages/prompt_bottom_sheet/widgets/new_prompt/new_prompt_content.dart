import 'package:flutter/material.dart';

import '../tab_bar.dart';
import 'new_private_prompt_content.dart';
import 'new_public_prompt_content.dart';

class NewPromptDialogContent extends StatefulWidget {
  const NewPromptDialogContent({super.key});

  @override
  State<NewPromptDialogContent> createState() => _NewPromptDialogContentState();
}

class _NewPromptDialogContentState extends State<NewPromptDialogContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                children: const [
                  NewPrivatePromptContent(),
                  NewPublicPromptContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

