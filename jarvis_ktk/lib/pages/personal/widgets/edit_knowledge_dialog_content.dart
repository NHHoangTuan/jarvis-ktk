import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/common_widgets.dart';

class EditKnowledgeDialogContent extends StatefulWidget {
  final Knowledge knowledge;
  final Function(String, String) onAdd;

  const EditKnowledgeDialogContent({super.key, required this.onAdd, required this.knowledge});

  @override
  // ignore: library_private_types_in_public_api
  _EditKnowledgeDialogContentState createState() =>
      _EditKnowledgeDialogContentState();
}

class _EditKnowledgeDialogContentState extends State<EditKnowledgeDialogContent> {
  String? knowledgeName = "";
  String? knowledgeDescription = "";

  @override
  void initState() {
    knowledgeName = widget.knowledge.knowledgeName;
    knowledgeDescription = widget.knowledge.description;
    super.initState();
  }

  void _updateKnowledge() {
    widget.onAdd(knowledgeName!, knowledgeDescription!);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
          height: 270,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.token, size: 30),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('* Knowledge Name',
                          style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      PromptTextFormField(
                        hintText: 'e.g: [TOPIC] Knowledge',
                        hintMaxLines: 1,
                        initialValue: widget.knowledge.knowledgeName,
                        onChanged: (value) {
                          knowledgeName = value;
                          _updateKnowledge();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('* Knowledge Description',
                          style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      PromptTextFormField(
                        hintText:
                        'e.g: This knowledge is about [TOPIC] and it contains information about [KEYWORDS]',
                        hintMaxLines: 2,
                        initialValue: widget.knowledge.description,
                        onChanged: (value) {
                          knowledgeDescription = value;
                          _updateKnowledge();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

