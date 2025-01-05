import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';

class EmailTabBar extends StatelessWidget {
  final TabController tabController;

  const EmailTabBar({required this.tabController, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 16.0),
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
            color: SimpleColors.navyBlue,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(
              child: Text('Response Email',
                  style:
                  TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            Tab(
              child: Text('Suggest Reply Ideas',
                  style:
                  TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
