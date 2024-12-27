import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/email_reply.dart';
import 'package:jarvis_ktk/data/network/email_api.dart';
import 'package:jarvis_ktk/pages/email_reply/reply_draft_page.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

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

  void _sendMessage(String? action) {
    if (_controller.text.isEmpty && action == null) return;

    if (action != null) {
      _controller.text = action;
    }

    addMessage(_controller.text);
  }

  Future<void> _sendResponseEmail(EmailReply emailReply) async {
    setState(() {
      _messages.add(ChatMessage(
        message: _controller.text.isEmpty ? emailReply.email : _controller.text,
        isBot: false,
        onSendMessage: _sendMessage,
      ));
    });

    scrollToBottom();

    if (_controller.text.isNotEmpty) {
      emailReply.mainIdea = _controller.text;
      _controller.clear();
    }

    try {
      final result = await getIt<EmailApi>().responseEmail(emailReply);
      emailReply.email = result.email;
      lastEmailReply = emailReply;

      setState(() {
        _messages.add(ChatMessage(
          message: result.email,
          isBot: true,
          onSendMessage: _sendMessage,
          isPreviousMessage: true,
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          message: e.toString(),
          isBot: true,
          onSendMessage: _sendMessage,
          isPreviousMessage: true,
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

  void addMessage(String message) {
    setState(() {});

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 200,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
                          message: _messages[index].message,
                          isBot: _messages[index].isBot,
                          onSendMessage: _messages[index].onSendMessage,
                          isPreviousMessage: index == _messages.length - 1,
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
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
