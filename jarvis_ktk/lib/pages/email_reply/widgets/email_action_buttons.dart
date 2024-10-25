import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class EmailActionsButtons extends StatelessWidget {
  final List<String> actions;
  final void Function(String) onPressed;

  const EmailActionsButtons({
    super.key,
    required this.actions,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          ...actions.map((action) {
            return SizedBox(
              height: 28.0,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  backgroundColor: SimpleColors.steelBlue.withOpacity(0.15),
                ),
                onPressed: () => onPressed(action),
                child: Text(
                  action,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SimpleColors.royalBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
