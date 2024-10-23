import 'package:flutter/material.dart';

class PromptTabBar extends StatelessWidget {
  final TabController tabController;

  const PromptTabBar({required this.tabController, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            controller: tabController,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.black,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(
                child: Text('My Prompt',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text('Public Prompt',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
