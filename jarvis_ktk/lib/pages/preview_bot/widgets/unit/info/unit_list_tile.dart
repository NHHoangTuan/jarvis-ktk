import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

import 'unit_info_dialog.dart';

class UnitListTile extends StatelessWidget {
  final Unit unit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleEnabled;

  const UnitListTile(
      {super.key,
      required this.unit,
      required this.onDelete,
      required this.onToggleEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 32.0,
                    height: 32.0,
                    child: ResizedImage(imagePath: dataSourceTypeToString(unit.type).imagePath , width: 32, height: 32),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child:
                    Text(
                      unit.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 32.0,
                    height: 32.0,
                    child: IconButton(
                      icon: const Icon(Icons.info_outline, size: 16),
                      onPressed: () {
                        UnitInfoDialog.show(context, unit);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 32.0,
                    height: 32.0,
                    child: IconButton(
                      alignment: Alignment.center,
                      icon: Icon(
                        unit.status
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: unit.status ? Colors.black : null,
                        size: 16,
                      ),
                      onPressed: () {
                        onToggleEnabled(!unit.status);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 32.0,
                    height: 32.0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, size: 16),
                      onPressed: onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Source: ${unit.name}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Size: ${unit.size}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
