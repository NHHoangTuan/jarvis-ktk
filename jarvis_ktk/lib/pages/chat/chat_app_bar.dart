import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
import 'widgets/select_agent_dropdown.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  ChatAppBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatModel = Provider.of<ChatModel>(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue[50],
      titleSpacing: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SelectAgentDropdown(
                  selectedAgent: chatModel.selectedAgent,
                  aiAgents: chatModel.aiAgents,
                  onChanged: (value) {
                    chatModel.setSelectedAgent(value!);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${chatModel.tokenCount}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onSelected: (String choice) {
            if (choice == 'New Chat') {
              chatModel.clearMessages();
            }
          },
          itemBuilder: (BuildContext context) {
            return {'New Chat'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: ListTile(
                  leading: const Icon(Icons.chat),
                  title: Text(choice),
                ),
              );
            }).toList();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}
