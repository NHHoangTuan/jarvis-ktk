import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/data/providers/token_provider.dart';
import 'package:jarvis_ktk/services/cache_service.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';
import 'package:provider/provider.dart';

import '../../data/network/token_api.dart';

import '../../services/service_locator.dart';

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
  bool _isLoadingToken = false;

  @override
  void initState() {
    super.initState();
    _handleLoadTokenUsage();
  }

  Future<void> _handleLoadTokenUsage() async {
    setState(() {
      _isLoadingToken = true;
    });
    try {
      await Provider.of<TokenProvider>(context, listen: false).loadTokenUsage();
    } catch (e) {
      debugPrint('Error loading token usage: $e');
    } finally {
      setState(() {
        _isLoadingToken = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.blue[50],
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SelectAgentDropdown(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isLoadingToken)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                else
                  Consumer<TokenProvider>(
                    builder: (context, tokenProvider, child) {
                      return TokenDisplay(
                          tokenCount: tokenProvider.currentToken);
                    },
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
              chatProvider.clearChatHistory();
              chatProvider.selectConversationId('');
              chatProvider.setShowWelcomeMessage(true);
              CacheService.clearChatHistoryCache();
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

class TokenDisplay extends StatelessWidget {
  final int tokenCount;

  const TokenDisplay({super.key, required this.tokenCount});

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
          const ResizedImage(
            imagePath: 'assets/fire_2.png',
            width: 18,
            height: 18,
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
