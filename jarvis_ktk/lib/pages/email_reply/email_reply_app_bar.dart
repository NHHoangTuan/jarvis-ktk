import 'package:flutter/material.dart';

class EmailReplyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const EmailReplyAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Email reply',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          transform: Matrix4.translationValues(0, 2, 0),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.blue,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '73',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
