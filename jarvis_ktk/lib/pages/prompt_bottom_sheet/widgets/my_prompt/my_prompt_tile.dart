import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/delete_prompt_dialog.dart';

import '../../../../data/models/prompt.dart';
import 'edit_my_prompt_dialog.dart';

class MyPromptTile extends StatefulWidget {
  final MyPrompt prompt;
  final VoidCallback onDelete;

  const MyPromptTile({super.key, required this.prompt, required this.onDelete});

  @override
  State<MyPromptTile> createState() => _MyPromptTileState();
}

class _MyPromptTileState extends State<MyPromptTile> {


  void onUpdate(MyPrompt prompt) {
    setState(() {
      widget.prompt.title = prompt.title;
      widget.prompt.content = prompt.content;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ListTile title
          Expanded(
            child: Text(
              widget.prompt.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
                    showEditMyPromptDialog(context, widget.prompt, onUpdate);
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
                    showConfirmDeletePromptDialog(context, widget.prompt, widget.onDelete);
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