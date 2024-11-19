import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import '../../../../data/models/prompt.dart';
import 'edit_my_prompt_dialog.dart';

class MyPromptTile extends StatelessWidget {
  final MyPrompt prompt;
  final VoidCallback onDelete;

  const MyPromptTile({super.key, required this.prompt, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ListTile title
          Text(
            prompt.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(0.0),
                width: 32.0,
                height: 32.0,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    showEditPromptDialog(context, prompt);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(0.0),
                width: 32.0,
                height: 32.0,
                child: IconButton(
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () {
                    showConfirmDeletePromptDialog(context, prompt, onDelete);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showConfirmDeletePromptDialog(
    BuildContext context, MyPrompt prompt, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this prompt?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              try {
                await getIt<PromptApi>().deletePrompt(prompt.id!);
                onDelete();
                if (!context.mounted) return;
                Navigator.of(context).pop();
              } catch (e) {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text('Failed to delete prompt: $e'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
