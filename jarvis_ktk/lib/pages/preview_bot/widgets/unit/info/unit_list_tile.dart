import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

import 'unit_info_dialog.dart';

class UnitListTile extends StatefulWidget {
  final Unit unit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onLoading;

  const UnitListTile({super.key, required this.unit, required this.onDelete, required this.onLoading});

  @override
  State<UnitListTile> createState() => _UnitListTileState();
}

class _UnitListTileState extends State<UnitListTile> {


  Future<void> onToggleEnabled(bool status) async {
    widget.onLoading(true);
    try {
      await getIt<KnowledgeApi>().updateUnitStatus(widget.unit.id, status);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update unit status'),
        ),
      );
      return;
    }
    setState(() {
      widget.unit.status = status;
    });
    widget.onLoading(false);
  }

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
                    child: ResizedImage(
                        imagePath:
                            dataSourceTypeToString(widget.unit.type).imagePath,
                        width: 32,
                        height: 32),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      widget.unit.name,
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
                        UnitInfoDialog.show(context, widget.unit);
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
                        widget.unit.status
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: widget.unit.status ? Colors.black : null,
                        size: 16,
                      ),
                      onPressed: () {
                        onToggleEnabled(!widget.unit.status);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 32.0,
                    height: 32.0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, size: 16),
                      onPressed: widget.onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Source: ${getMetadata(widget.unit)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Size: ${widget.unit.size}',
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

String getMetadata(Unit unit) {
  switch (unit.type) {
    case DataSourceType.local_file:
      return unit.metadata['name']!;
    case DataSourceType.web:
      return unit.metadata['web_url']!;
    case DataSourceType.confluence:
      return unit.metadata['wiki_page_url']!;
    case DataSourceType.slack:
      return unit.metadata['slack_workspace']!;

    case DataSourceType.google_drive:
      break;
  }
  return '';
}
