import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';

class UnitInfoDialog extends StatelessWidget {
  final Unit unit;

  const UnitInfoDialog({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    // Format the date
    final String formattedDate = DateFormat.yMMMd().format(unit.createdAt);


    return AlertDialog(
      title: Text(unit.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Source: ${unit.name}'),
          const SizedBox(height: 8),
          Text('Size: ${unit.size}'),
          const SizedBox(height: 8),
          Text('Creation Date: $formattedDate'),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Enabled:'),
              const SizedBox(width: 4),
              Icon(
                unit.status ? Icons.check_circle : Icons.cancel,
                color: unit.status ? Colors.green : Colors.red,
                size: 16,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  /// Static method to show the dialog.
  static Future<void> show(BuildContext context, Unit unit) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return UnitInfoDialog(unit: unit);
      },
    );
  }
}
