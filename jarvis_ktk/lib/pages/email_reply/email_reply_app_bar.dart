import 'package:flutter/material.dart';

class EmailReplyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const EmailReplyAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const EmailReplyTitle(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
  }
}

class EmailReplyTitle extends StatelessWidget {
  const EmailReplyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Adjusts row size to fit content
      children: [
        const Text(
          'Email reply', // The label
          style: TextStyle(
            fontSize: 16, // Text size
            fontWeight: FontWeight.w500, // Text weight
          ),
        ),
        const SizedBox(width: 8), // Space between text and icon
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          transform: Matrix4.translationValues(0, 2, 0),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1), // Background color
            borderRadius: BorderRadius.circular(8), // Border radius
          ),
          child: const Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.blue,
                size: 16,
              ),
              SizedBox(width: 4), // Space between icon and number
              Text(
                '73', // Number to display
                style: TextStyle(
                  fontSize: 12, // Text size
                  fontWeight: FontWeight.w500, // Text weight
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
