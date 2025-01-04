import 'package:flutter/material.dart';

import '../../../data/models/prompt.dart';
import '../../../data/models/user.dart';

class PromptWidget extends StatelessWidget {
  final Future<List<Prompt>> promptsFuture;
  final TextEditingController messageController;
  final VoidCallback onClosePromptList;
  final User? user;

  const PromptWidget({
    Key? key,
    required this.promptsFuture,
    required this.messageController,
    required this.onClosePromptList,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prompt>>(
      future: promptsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No prompts available'));
        } else {
          final prompts = snapshot.data!;
          final filteredPrompts = prompts.where((prompt) {
            if (prompt is PublicPrompt) {
              return prompt.isFavorite || prompt.userId == user?.id;
            }
            return true;
          }).toList();
          final myPrompts = filteredPrompts.whereType<MyPrompt>().toList();
          final publicPrompts =
              filteredPrompts.whereType<PublicPrompt>().toList();
          return SizedBox(
            height: 200,
            child: ListView(
              children: [
                if (myPrompts.isNotEmpty) ...[
                  const ListTile(
                    title: Text('My Prompts',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...myPrompts.map((prompt) => ListTile(
                        title: Text(prompt.title),
                        onTap: () {
                          messageController.text = prompt.content;
                          onClosePromptList();
                        },
                      )),
                ],
                if (publicPrompts.isNotEmpty) ...[
                  const ListTile(
                    title: Text('Public Prompts',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...publicPrompts.map((prompt) => ListTile(
                        title: Text(prompt.title),
                        onTap: () {
                          messageController.text = prompt.content;
                          onClosePromptList();
                        },
                      )),
                ],
              ],
            ),
          );
        }
      },
    );
  }
}
