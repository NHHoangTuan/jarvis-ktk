import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/data/providers/token_provider.dart';
import 'package:jarvis_ktk/services/cache_service.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../data/network/token_api.dart';

import '../../services/service_locator.dart';

import 'widgets/select_agent_dropdown.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  final Size preferredSize;

  const ChatAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _ChatAppBarState extends State<ChatAppBar> {
  final tokenApi = getIt<TokenApi>();
  bool _isLoadingToken = false;
  bool _isLoadingBot = false;

  @override
  void initState() {
    super.initState();
    _handleLoadTokenUsage();
    _handleLoadBots();
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

  Future<void> _handleLoadBots() async {
    setState(() {
      _isLoadingBot = true;
    });
    try {
      final botProvider = Provider.of<BotProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await botProvider.loadBots();
      for (final bot in botProvider.bots) {
        // kiểm tra nếu bot là favorite và không nằm trong ai agent thì thêm vào
        if (bot.isFavorite &&
            !chatProvider.aiAgents.any((element) => element['id'] == bot.id)) {
          chatProvider.addBotToAiAgents(bot);
        }
      }
    } catch (e) {
      debugPrint('Error loading bots: $e');
    } finally {
      setState(() {
        _isLoadingBot = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
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
                // if (chatProvider.isBOT)
                //   if (_isLoadingBot)
                //     LoadingAnimationWidget.twistingDots(
                //       leftDotColor: const Color(0xFF1A1A3F),
                //       rightDotColor: const Color(0xFFEA3799),
                //       size: 20,
                //     )
                //   else
                //     const SelectBotDropdown()
                // else
                if (_isLoadingBot)
                  LoadingAnimationWidget.twistingDots(
                    leftDotColor: const Color(0xFF1A1A3F),
                    rightDotColor: const Color(0xFFEA3799),
                    size: 20,
                  )
                else
                  const SelectAgentDropdown(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isLoadingToken)
                  LoadingAnimationWidget.twistingDots(
                    leftDotColor: const Color(0xFF1A1A3F),
                    rightDotColor: const Color(0xFFEA3799),
                    size: 20,
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
            if (choice == 'newchat') {
              chatProvider.clearChatHistory();
              chatProvider.selectConversationId('');
              chatProvider.setShowWelcomeMessage(true);
              CacheService.clearChatHistoryCache();
            } else if (choice == 'switchaiagent') {
              chatProvider.setBOT(!chatProvider.isBOT);
              chatProvider.clearChatHistory();
              chatProvider.selectConversationId('');
              chatProvider.setShowWelcomeMessage(true);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'newchat',
              child: ListTile(
                leading: Icon(Icons.chat_outlined),
                title: Text('New Chat'),
              ),
            ),
            // const PopupMenuItem<String>(
            //   value: 'switchaiagent',
            //   child: ListTile(
            //     leading: Icon(Icons.swap_horizontal_circle_outlined),
            //     title: Text('Switch AI Agent'),
            //   ),
            // ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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