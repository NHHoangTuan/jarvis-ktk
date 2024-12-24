import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/token_usage.dart';
import '../../data/network/token_api.dart';
import '../../services/cache_service.dart';
import '../../services/service_locator.dart';
import 'chat_model.dart';
import 'widgets/select_agent_dropdown.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  final Size preferredSize;

  const ChatAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _ChatAppBarState extends State<ChatAppBar> {
  final tokenApi = getIt<TokenApi>();
  StreamController<TokenUsage?> _tokenUsageController =
      StreamController<TokenUsage?>.broadcast();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInitialTokens();
  }

  Future<void> _loadInitialTokens() async {
    final tokens = await CacheService.getCachedTokenUsage(tokenApi);
    _tokenUsageController.add(tokens);
  }

  Future<void> _refreshTokens() async {
    if (_tokenUsageController.isClosed) return;
    final tokens = await CacheService.getCachedTokenUsage(tokenApi);
    _tokenUsageController.add(tokens);
  }

  @override
  Widget build(BuildContext context) {
    final chatModel = Provider.of<ChatModel>(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue[50],
      scrolledUnderElevation: 0,
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
                StreamBuilder<TokenUsage?>(
                    stream: _tokenUsageController.stream,
                    initialData: null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.data?.availableTokens != null &&
                          snapshot.data?.availableTokens !=
                              chatModel.tokenCount) {
                        _refreshTokens();
                      }

                      final tokenCount = snapshot.data?.availableTokens ?? 0;
                      return TokenDisplay(tokenCount: tokenCount);
                    })
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
              chatModel.resetConversationId();
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

  @override
  void dispose() {
    _tokenUsageController.close();
    super.dispose();
  }
}

class TokenDisplay extends StatelessWidget {
  final int tokenCount;

  const TokenDisplay({required this.tokenCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            '$tokenCount',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
