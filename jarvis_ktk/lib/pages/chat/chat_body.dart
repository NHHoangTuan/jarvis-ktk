import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/models/user.dart';
import 'package:jarvis_ktk/data/network/chat_api.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:provider/provider.dart';

import '../../services/cache_service.dart';
import '../prompt_bottom_sheet/prompt_bottom_sheet.dart';
import 'chat_model.dart';
import 'widgets/message_bubble.dart';
import 'widgets/welcome.dart';

class ChatBody extends StatefulWidget {
  final String? conversationId;

  const ChatBody({
    super.key,
    this.conversationId,
  });

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late Future<List<Prompt>> _promptsFuture;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late TextEditingController _messageController;
  late FocusNode _messageFocusNode;
  bool _showPromptList = false;
  User? _user;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageFocusNode = FocusNode();
    _messageController.addListener(_handleSlashAction);
    _initialize();
  }

  Future<void> _initialize() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        _user = User.fromJson(userMap);
      });
    }
    if (_user != null) {
      _promptsFuture = getIt<PromptApi>().getPrompts();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _handleSlashAction() {
    if (_messageController.text.startsWith('/') && _user != null) {
      setState(() {
        _showPromptList = true;
      });
    } else {
      setState(() {
        _showPromptList = false;
      });
    }
  }

  Future<void> _sendMessage(ChatModel chatModel) async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final selectedAI = chatModel.aiAgents.firstWhere(
      (agent) => agent['id'] == chatModel.selectedAgent,
    );

    final userMessage = _messageController.text;

    chatModel.addMessage({
      'text': userMessage,
      'isUser': true,
      'timestamp': DateTime.now(),
      'avatar': 'assets/user_avatar.jpg',
    });

    chatModel.addMessage({
      'text': '',
      'isUser': false,
      'timestamp': DateTime.now(),
      'avatar': selectedAI['avatar'],
    });

    _messageController.clear();
    _messageFocusNode.unfocus();
    chatModel.hideWelcomeMessage();

    final chatApi = getIt<ChatApi>();

    // Gửi tin nhắn qua API và nhận phản hồi
    try {
      final response = await chatApi.sendMessage({
        'content': userMessage,
        "metadata": {
          "conversation": {"id": chatModel.conversationId},
        },
        "assistant": {"id": chatModel.selectedAgent, "model": "dify"}
      });

      if (response.statusCode == 200) {
        var remainingUsage = response.data['remainingUsage'];
        chatModel.setTokenCount(remainingUsage);
        CacheService.updateAvailableTokenUsage(remainingUsage);

        var conversationId = response.data['conversationId'];
        chatModel.setConversationId(conversationId);

        final newMessage = {
          'text': response.data['message'],
          'isUser': false,
          'timestamp': DateTime.now(),
          'avatar': selectedAI['avatar'],
        };
        // Cập nhật dữ liệu vào ChatModel
        chatModel.updateMessage(chatModel.messages.length - 1, newMessage);
        CacheService.setCurrentHistoryLength(
            CacheService.getCurrentHistoryLength() + 1);
      } else {
        // Parse error message từ response data
        final details = response.data['details'] as List;
        if (details.isNotEmpty) {
          final issue = details[0]['issue'] as String;
          showToast(issue);

          // Xóa tin nhắn cuối cùng nếu có lỗi
          chatModel.removeMessage(chatModel.messages.length - 1);
          chatModel.removeMessage(chatModel.messages.length - 1);
        }
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    final chatModel = Provider.of<ChatModel>(context);
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: chatModel.showWelcomeMessage
                  ? const WelcomeMessage()
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: chatModel.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatModel
                            .messages[chatModel.messages.length - 1 - index];
                        return MessageBubble(
                          text: message['text'],
                          isUser: message['isUser'],
                          timestamp: message['timestamp'],
                          avatar: message['avatar'],
                          isLoading:
                              !message['isUser'] && index == 0 && _isLoading,
                        );
                      },
                    ),
            ),
            if (_showPromptList)
              FutureBuilder<List<Prompt>>(
                future: _promptsFuture,
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
                        return prompt.isFavorite || prompt.userId == _user?.id;
                      }
                      return true;
                    }).toList();
                    final myPrompts =
                        filteredPrompts.whereType<MyPrompt>().toList();
                    final publicPrompts =
                        filteredPrompts.whereType<PublicPrompt>().toList();
                    return SizedBox(
                      height: 200,
                      child: ListView(
                        children: [
                          if (myPrompts.isNotEmpty) ...[
                            const ListTile(
                              title: Text('My Prompts',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            ...myPrompts.map((prompt) => ListTile(
                                  title: Text(prompt.title),
                                  onTap: () {
                                    _messageController.text = prompt.content;
                                    setState(() {
                                      _showPromptList = false;
                                    });
                                  },
                                )),
                          ],
                          if (publicPrompts.isNotEmpty) ...[
                            const ListTile(
                              title: Text('Public Prompts',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            ...publicPrompts.map((prompt) => ListTile(
                                  title: Text(prompt.title),
                                  onTap: () {
                                    _messageController.text = prompt.content;
                                    setState(() {
                                      _showPromptList = false;
                                    });
                                  },
                                )),
                          ],
                        ],
                      ),
                    );
                  }
                },
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
                          showPromptBottomSheet(context, onClick: (prompt) {
                            _messageController.text = prompt.content;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        // Fixed height for the text box
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
                          maxLines: 4,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical
                              .center, // Center vertical alignment
                        ),
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
