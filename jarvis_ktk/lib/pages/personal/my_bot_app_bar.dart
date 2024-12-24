import 'package:flutter/material.dart';
import '../preview_bot/widgets/dialog/edit_preview_bot.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyBotAppBar extends StatefulWidget implements PreferredSizeWidget {
  State<MyBotAppBar> createState() => _MyBotAppBarState();
  //final VoidCallback onApply;

  @override
  final Size preferredSize;

  const MyBotAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _MyBotAppBarState extends State<MyBotAppBar> {
  Widget _buildDialogHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Create Bot'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

  void _showCreateBotDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: _buildDialogHeader(),
        content: EditPreviewBotPage(),
      ),
    );
  }

  Widget _buildCreateBotButton() => SizedBox(
        height: 40,
        child: IconButton(
          onPressed: () => showCupertinoModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                const SingleChildScrollView(child: EditPreviewBotPage()),
            enableDrag: false,
          ),
          icon: const Icon(
            Icons.add_circle_outline,
            color: Colors.black,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue[50],
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Expanded(
            flex: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('My Bot'),
              ],
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 2,
            child: _buildCreateBotButton(),
          ),
        ],
      ),
    );
  }
}
