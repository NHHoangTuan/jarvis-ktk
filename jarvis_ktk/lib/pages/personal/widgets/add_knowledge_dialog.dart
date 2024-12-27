import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/common_widgets.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import 'add_knowledge_personal.dart';

class AddKnowledgeDialog extends StatefulWidget {
  final VoidCallback onSave;

  const AddKnowledgeDialog({super.key, required this.onSave});

  @override
  State<AddKnowledgeDialog> createState() => _AddKnowledgeDialog();
}

class _AddKnowledgeDialog extends State<AddKnowledgeDialog> {
  bool _isLoading = false;
  String knowledgeName = '';
  String knowledgeDescription = '';

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
      title: const AddKnowledgeDialogTitle(),
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AddKnowledgePersonalPage(onAdd: _onUpdateKnowledge),
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
        const CancelButton(),
        SaveButton(onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          try {
            await getIt<KnowledgeApi>()
                .createKnowledge(knowledgeName, knowledgeDescription);
            widget.onSave();
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to create knowledge"),
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

void showAddKnowledgeDialog(
  BuildContext context,
  VoidCallback onSave,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddKnowledgeDialog(onSave: onSave);
    },
  );
}

class AddKnowledgeDialogTitle extends StatelessWidget {

  const AddKnowledgeDialogTitle({super.key});

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
        const Text(
          "Add Knowledge",
          style: TextStyle(
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
