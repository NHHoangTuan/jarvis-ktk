import 'package:flutter/material.dart';

import 'widgets/app_bar.dart';
import 'widgets/my_prompt/my_prompt_content.dart';
import 'widgets/public_prompt/public_prompt_content.dart';
import 'widgets/tab_bar.dart';

void showPromptBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    isScrollControlled: true,
    builder: (context) => const PromptBottomSheet(),
  );
}

class PromptBottomSheet extends StatefulWidget {
  const PromptBottomSheet({super.key});

  @override
  State<PromptBottomSheet> createState() => _PromptBottomSheetState();
}

class _PromptBottomSheetState extends State<PromptBottomSheet>
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PromptAppBar(),
        PromptTabBar(
          tabController: _tabController,
        ),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: const [
              MyPromptContent(),
              PublicPromptContent(),
            ],
          ),
        ),
      ],
    );
  }
}
