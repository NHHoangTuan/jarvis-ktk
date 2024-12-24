import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

class AddKnowledgePersonaPage extends StatefulWidget {
  final VoidCallback onAdd;

  const AddKnowledgePersonaPage({super.key, required this.onAdd});

  @override
  // ignore: library_private_types_in_public_api
  _AddKnowledgePersonaPageState createState() =>
      _AddKnowledgePersonaPageState();
}

class _AddKnowledgePersonaPageState extends State<AddKnowledgePersonaPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.token, size: 40),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: ' Knowledge Name',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _nameController,
              maxLength: 50,
              decoration: InputDecoration(
                counterText: '${_nameController.text.length}/50',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Knowledge Description"),
            TextField(
              controller: _descriptionController,
              maxLength: 2000,
              maxLines: 5,
              decoration: InputDecoration(
                counterText: '${_descriptionController.text.length}/2000',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        try {
                          getIt<KnowledgeApi>().createKnowledge(
                            _nameController.text,
                            _descriptionController.text,
                          );
                        }
                        catch (e) {
                          Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }
                        widget.onAdd();
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: const Text("Confirm"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
