import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/common_widgets.dart';

class AddKnowledgePersonalPage extends StatefulWidget {
  final Function(String, String) onAdd;

  const AddKnowledgePersonalPage({super.key, required this.onAdd});

  @override
  // ignore: library_private_types_in_public_api
  _AddKnowledgePersonalPageState createState() =>
      _AddKnowledgePersonalPageState();
}

class _AddKnowledgePersonalPageState extends State<AddKnowledgePersonalPage> {
  String? knowledgeName = '';
  String? knowledgeDescription = '';

  void _updateKnowledge() {
    widget.onAdd(knowledgeName!, knowledgeDescription!);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.school_rounded, size: 40),
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
                        'e.g: This knowledge is about [TOPIC], it covers [SUBTOPIC]',
                    hintMaxLines: 2,
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
