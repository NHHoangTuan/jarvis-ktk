import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/models/email_reply.dart';
import 'package:jarvis_ktk/data/network/email_api.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/pages/email_reply/reply_draft_page.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:provider/provider.dart';

import 'widgets/chat_input.dart';
import 'widgets/chat_message.dart';

class EmailReplyPage extends StatefulWidget {
  const EmailReplyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailReplyPage createState() => _EmailReplyPage();
}

class _EmailReplyPage extends State<EmailReplyPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late EmailReply lastEmailReply;

  void _onRetry(EmailReply emailReply) {
    _sendResponseEmail(emailReply, retry: true);
  }

  void _onAction(String action) async {
    _controller.text = action;
    _sendResponseEmail(lastEmailReply);
  }

  Future<void> _sendResponseEmail(EmailReply emailReply,
      {bool retry = false}) async {
    final chatProvider = context.read<ChatProvider>();
    final selectedAiAgent = chatProvider.selectedAiAgent;
    final Map<String, String> assistant = {
      'id':selectedAiAgent['id']!,
      'model': AssistantModel.DIFY.name,
    };
    if (retry) {
      _messages.removeAt(_messages.length - 1);
    } else {
      setState(() {
        _messages.add(ChatMessage(
          message:
              _controller.text.isEmpty ? emailReply.email : _controller.text,
          isBot: false,
          onSendMessage: _onAction,
        ));
      });

      scrollToBottom();

      if (_controller.text.isNotEmpty) {
        emailReply.mainIdea = _controller.text;
        _controller.clear();
      }
    }

    setState(() {
      _messages.add(ChatMessage(
        botName: selectedAiAgent['name'],
        message: "Loading",
        isBot: true,
        onSendMessage: _onAction,
        isPreviousMessage: true,
      ));
    });

    try {

      final result = await getIt<EmailApi>().responseEmail(emailReply, assistant);
      emailReply.email = result.email;
      lastEmailReply = emailReply;

      setState(() {
        _messages.removeAt(_messages.length - 1);
        _messages.add(ChatMessage(
          botName: selectedAiAgent['name'],
          message: result.email,
          isBot: true,
          onSendMessage: _onAction,
          isPreviousMessage: true,
          onRetry: () => _onRetry(emailReply),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.removeAt(_messages.length - 1);
        _messages.add(ChatMessage(
          botName: selectedAiAgent['name'],
          message: "Failed to response email",
          isBot: true,
          onSendMessage: _onAction,
          isPreviousMessage: true,
          onRetry: () => _onRetry(emailReply),
        ));
      });
    }
    scrollToBottom();
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        maxScrollExtent + 200,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _messages.isEmpty
                      ? ReplyDraftScreen(onSendMessage: _sendResponseEmail)
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ChatMessage(
                              botName: _messages[index].botName,
                              message: _messages[index].message,
                              isBot: _messages[index].isBot,
                              onSendMessage: _messages[index].onSendMessage,
                              isPreviousMessage: index == _messages.length - 1,
                              onRetry: _messages[index].onRetry,
                            );
                          },
                        ),
                ),
                // chat input
                if (_messages.isNotEmpty)
                  ChatInput(
                    controller: _controller,
                    onSendMessage: () => _sendResponseEmail(lastEmailReply),
                    onClearMessages: () {
                      setState(() {
                        _messages.clear();
                      });
                    },
                  ),
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
