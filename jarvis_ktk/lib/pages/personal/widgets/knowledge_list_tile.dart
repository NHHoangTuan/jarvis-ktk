import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';

import 'edit_knowledge_dialog.dart';

class KnowledgeListTile extends StatefulWidget {
  final Knowledge knowledge;
  final VoidCallback onDelete;
  final Function(Knowledge) onAllUnitsTap;

  const KnowledgeListTile({super.key,
    required this.knowledge,
    required this.onDelete,
    required this.onAllUnitsTap,
  });

  @override
  State<KnowledgeListTile> createState() => _KnowledgeListTileState();
}

  class _KnowledgeListTileState extends State<KnowledgeListTile> {

  void onSave(String knowledgeName, String description) {
    setState(() {
      widget.knowledge.knowledgeName = knowledgeName;
      widget.knowledge.description = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.5),
            child: InkWell(
              onTap: () {
                showEditKnowledgeDialog(context, onSave, widget.onDelete, widget.knowledge);
              },
              splashColor: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.0),
              splashFactory: InkRipple.splashFactory,
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffffcae5), Color(0xffffe3f6)],
                    stops: [0.4, 1.0],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.knowledge.knowledgeName,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFa12367),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.token,
                            color: Color(0xFFa12367),
                            size: 24.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.knowledge.description,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFFa12367),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.knowledge.updatedAt.formatted,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFa12367),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• ${widget.knowledge.numUnits} units',
                            style: const TextStyle(
                              color: Color(0xFFa12367),
                            ),
                          ),
                          TextButton(
                            onPressed: () => widget.onAllUnitsTap(widget.knowledge),
                            child: const Text(
                              'All units →',
                              style: TextStyle(
                                color: Color(0xFFa12367),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ),
        ],
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String get formatted {
    final monthName = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][month - 1];
    return '${monthName.substring(0, 3)} ${day.toString().padLeft(
        2, '0')}, $year ${hour.toString().padLeft(2, '0')}:${minute.toString()
        .padLeft(2, '0')} ${hour > 12 ? 'PM' : 'AM'}';
  }
}
