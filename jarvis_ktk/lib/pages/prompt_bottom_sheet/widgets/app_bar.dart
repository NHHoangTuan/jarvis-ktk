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
        SizedBox(
          height: 43,
          width: 43,
          child: IconButton(
            iconSize: 25,
            icon: const Icon(Icons.add_circle),
            color: const Color(0xFF611FEC),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(
            height: 32,
            width: 32,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconSize: 16,
            ),
          ),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
  }
}
