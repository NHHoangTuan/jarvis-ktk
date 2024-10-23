import 'package:flutter/material.dart';

class PromptAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const PromptAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('Prompt Library',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      automaticallyImplyLeading: false,
      actions: [
        Ink(
          height: 34,
          width: 34,
          decoration: const ShapeDecoration(
            color: Color(0xFF611FEC),
            shape: CircleBorder(),
          ),
          child: IconButton(
            iconSize: 18,
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
  }
}