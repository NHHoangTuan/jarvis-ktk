import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../prompt_bottom_sheet/prompt_bottom_sheet.dart';
import 'chat_model.dart';
import 'widgets/message_bubble.dart';
import 'widgets/welcome.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ChatBody extends StatefulWidget {
  final bool
      isHistory; // Thêm tham số để xác định có phải đang xem lịch sử không
  final List<Map<String, dynamic>>?
      historyChatMessages; // Thêm danh sách tin nhắn lịch sử

  const ChatBody({
    Key? key,
    this.isHistory = false,
    this.historyChatMessages,
  }) : super(key: key);

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late TextEditingController _messageController;
  late FocusNode _messageFocusNode;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _sendMessage(ChatModel chatModel) {
    if (_messageController.text.trim().isNotEmpty) {
      final selectedAI = chatModel.aiAgents.firstWhere(
        (agent) => agent['id'] == chatModel.selectedAgent,
      );

      final int tokensToDeduct = int.parse(selectedAI['tokens']!);
      chatModel.setTokenCount(chatModel.tokenCount - tokensToDeduct);

      final userMessage = _messageController.text;

      chatModel.addMessage({
        'text': userMessage,
        'isUser': true,
        'timestamp': DateTime.now(),
        'avatar': 'assets/user_avatar.jpg',
      });

      chatModel.addMessage({
        'text': userMessage,
        'isUser': false,
        'timestamp': DateTime.now(),
        'avatar': selectedAI['avatar'],
      });

      _messageController.clear();
      _messageFocusNode.unfocus();
      chatModel.hideWelcomeMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatModel = Provider.of<ChatModel>(context);

    // Quyết định danh sách tin nhắn sẽ hiển thị
    final messages = widget.isHistory
        ? widget.historyChatMessages ?? []
        : chatModel.messages;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: widget.isHistory
                  ? ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[messages.length - 1 - index];
                        return MessageBubble(
                          text: message['text'],
                          isUser: message['isUser'],
                          timestamp: message['timestamp'],
                          avatar: message['avatar'],
                        );
                      },
                    )
                  : chatModel.showWelcomeMessage
                      ? const WelcomeMessage()
                      : ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.all(16),
                          itemCount: chatModel.messages.length,
                          itemBuilder: (context, index) {
                            final message = chatModel.messages[
                                chatModel.messages.length - 1 - index];
                            return MessageBubble(
                              text: message['text'],
                              isUser: message['isUser'],
                              timestamp: message['timestamp'],
                              avatar: message['avatar'],
                            );
                          },
                        ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  children: [
                    DropdownSearch<(IconData, String)>(
                      mode: Mode.custom,
                      items: (f, cs) => [
                        (Icons.image, 'Upload image'),
                        (Icons.photo_camera, 'Take a photo'),
                        (Icons.electric_bolt, 'Prompt'),
                      ],
                      compareFn: (item1, item2) => item1.$1 == item2.$1,
                      popupProps: PopupProps.modalBottomSheet(
                        fit: FlexFit.loose,
                        itemBuilder: (context, item, isDisabled, isSelected) =>
                            Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            leading: Icon(item.$1, color: Colors.black),
                            title: Text(
                              item.$2,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      dropdownBuilder: (ctx, selectedItem) => const Icon(
                        Icons.add_box_outlined,
                        color: Colors.black,
                      ),
                      onChanged: (selectedItem) {
                        if (selectedItem != null &&
                            selectedItem.$2 == 'Prompt') {
                          showPromptBottomSheet(context);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(chatModel),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
