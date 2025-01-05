import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';

import 'widgets/app_bar.dart';
import 'widgets/my_prompt/my_prompt_content.dart';
import 'widgets/public_prompt/public_prompt_content.dart';
import 'widgets/tab_bar.dart';

void showPromptBottomSheet(BuildContext context, {required void Function(Prompt) onClick}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => PromptBottomSheet(onClick: onClick),
  );
}

class PromptBottomSheet extends StatefulWidget {
  final void Function(Prompt) onClick;

  const PromptBottomSheet({super.key, required this.onClick});

  @override
  State<PromptBottomSheet> createState() => _PromptBottomSheetState();
}

class _PromptBottomSheetState extends State<PromptBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<PublicPromptContentState> _publicPromptKey = GlobalKey<PublicPromptContentState>();
  final GlobalKey<MyPromptContentState> _myPromptKey = GlobalKey<MyPromptContentState>();

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
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 1.0,
      snap: true,
      snapAnimationDuration: const Duration(milliseconds: 400),
      snapSizes: const [0.6, 1.0],
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PromptAppBar(myPromptKey: _myPromptKey, publicPromptKey: _publicPromptKey),
                PromptTabBar(
                  tabController: _tabController,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.825,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      MyPromptContent(key: _myPromptKey, onClick: widget.onClick),
                      PublicPromptContent(key: _publicPromptKey, onClick: widget.onClick),
                    ],
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }
}