import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';

import 'unit_list_tile.dart';

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
          RichText(text: TextSpan(
            text: 'Source: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16
            ),
            children: [
              TextSpan(text: getMetadata(unit), style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 16
              )),
            ],
          )),
          const SizedBox(height: 8),
          RichText(text: TextSpan(
            text: 'Size: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16
            ),
            children: [
              TextSpan(text: unit.size.toString(), style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 16
              )),
            ],
          )),
          const SizedBox(height: 8),
          RichText(text: TextSpan(
            text: 'Creation Date: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16
            ),
            children: [
              TextSpan(text: formattedDate, style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 16
              )),
            ],
          )),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Enabled:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
