import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/common_widgets.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import 'edit_knowledge_dialog_content.dart';

class EditKnowledgeDialog extends StatefulWidget {
  final Knowledge knowledge;
  final Function(String, String) onSave;
  final VoidCallback onDelete;

  const EditKnowledgeDialog(
      {super.key,
      required this.onSave,
      required this.knowledge,
      required this.onDelete});

  @override
  State<EditKnowledgeDialog> createState() => _EditKnowledgeDialogState();
}

class _EditKnowledgeDialogState extends State<EditKnowledgeDialog> {
  bool _isLoading = false;
  String knowledgeName = '';
  String knowledgeDescription = '';

  @override
  void initState() {
    knowledgeName = widget.knowledge.knowledgeName;
    knowledgeDescription = widget.knowledge.description;
    super.initState();
  }

  void _onUpdateKnowledge(String name, String description) {
    setState(() {
      knowledgeName = name;
      knowledgeDescription = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      contentPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0),
      actionsPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 16),
      title: EditKnowledgeDialogTitle(
          knowledgeName: widget.knowledge.knowledgeName),
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: EditKnowledgeDialogContent(
                  onAdd: _onUpdateKnowledge, knowledge: widget.knowledge),
            ),
            if (_isLoading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
      insetPadding: const EdgeInsets.all(10),
      actions: [
        TextButton(
            onPressed: widget.onDelete,
            child: const Text('Delete', style: TextStyle(color: Colors.red))),
        SaveButton(onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          try {
            await getIt<KnowledgeApi>().updateKnowledge(
                widget.knowledge.id, knowledgeName, knowledgeDescription);
            widget.onSave(knowledgeName, knowledgeDescription);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Knowledge updated"),
              ),
            );
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to edit knowledge"),
              ),
            );
          }
          if (!context.mounted) return;
          Navigator.of(context).pop();
          setState(() {
            _isLoading = false;
          });
        }),
      ],
    );
  }
}

void showEditKnowledgeDialog(
  BuildContext context,
  Function(String, String) onSave,
  VoidCallback onDelete,
  Knowledge knowledge,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditKnowledgeDialog(
        onSave: onSave,
        knowledge: knowledge,
        onDelete: onDelete,
      );
    },
  );
}

class EditKnowledgeDialogTitle extends StatelessWidget {
  final String knowledgeName;

  const EditKnowledgeDialogTitle({super.key, required this.knowledgeName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // to balance the row
        const IconButton(
          icon: Icon(Icons.close, size: 16, color: Colors.transparent),
          onPressed: null,
        ),
        Text(
          knowledgeName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 16),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
