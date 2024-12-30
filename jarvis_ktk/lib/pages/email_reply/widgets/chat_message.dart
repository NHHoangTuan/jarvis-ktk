import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jarvis_ktk/pages/email_reply/widgets/email_action_buttons.dart';

import '../../../utils/colors.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isBot;
  final void Function(String) onSendMessage;
  final bool isPreviousMessage;
  final VoidCallback? onRetry;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isBot,
    required this.onSendMessage,
    this.isPreviousMessage = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return isBot
        ? BotMessage(
            message: message,
            onSendMessage: onSendMessage,
            isPreviousMessage: isPreviousMessage,
            onRetry: onRetry,
          )
        : UserMessage(message: message);
  }
}

List<String> emailActions = [
  "🙏 Thanks",
  "😔 Sorry",
  "👍 Yes",
  "👎 No",
  "📅 Follow up",
  "🤔 Request for more information",
];

class BotMessage extends StatefulWidget {
  final String message;
  final void Function(String) onSendMessage;
  final bool isPreviousMessage;
  final VoidCallback? onRetry;

  const BotMessage({
    super.key,
    required this.message,
    required this.onSendMessage,
    required this.isPreviousMessage,
    this.onRetry,
  });

  @override
  State<BotMessage> createState() => _BotMessageState();
}

class _BotMessageState extends State<BotMessage> {
  bool _isVisible = true;
  late EmailActionsButtons emailActionsButton;

  @override
  void initState() {
    super.initState();
    emailActionsButton = EmailActionsButtons(
      actions: emailActions,
      onPressed: widget.onSendMessage,
    );
  }

  @override
  void didUpdateWidget(BotMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isPreviousMessage && oldWidget.isPreviousMessage) {
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 0.7,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Jarvis reply",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: SimpleColors.royalBlue,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[300]!,
                  thickness: 0.7,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[300]!,
                  thickness: 0.7,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, bottom: 8, top: 0),
                  child: Row(
                    children: [
                      Transform.flip(
                        flipX: true,
                        child: SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: widget.message));
                            },
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.copy,
                                color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                      if (widget.onRetry != null)
                      Transform.flip(
                        flipX: true,
                        child: SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: IconButton(
                            onPressed: widget.onRetry,
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.replay,
                                color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.isPreviousMessage || !_isVisible)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _isVisible
                    ? KeyedSubtree(
                        key: const ValueKey('visible'),
                        child: emailActionsButton
                            .animate()
                            .fadeIn(duration: 500.ms),
                      )
                    : KeyedSubtree(
                        key: const ValueKey('invisible'),
                        child: emailActionsButton
                            .animate()
                            .slideX(begin: 0, end: -1, duration: 500.ms)
                            .fadeOut(duration: 700.ms)
                            .swap(
                          builder: (_, __) {
                            return const SizedBox.shrink();
                          },
                        ), // Replace with empty space when invisible
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class UserMessage extends StatelessWidget {
  final String message;

  const UserMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.7),
      // 16 + border width from UserMessage
      child: Container(
        margin: const EdgeInsets.only(top: 5.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: SimpleColors.babyBlue.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Received email",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
