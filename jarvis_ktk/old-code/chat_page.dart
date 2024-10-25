import 'package:flutter/material.dart';
import 'package:jarvis_ktk/widgets/custom_drawer.dart';
import 'package:jarvis_ktk/pages/chat/widgets/message_bubble.dart';
import 'package:jarvis_ktk/pages/chat/widgets/select_agent_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jarvis_ktk/pages/chat/widgets/welcome.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode(); // Tạo FocusNode
  String selectedAgent = '001';
  int tokenCount = 1000;
  List<Map<String, dynamic>> messages = [];
  bool isAttachingImage = false;
  bool showWelcomeMessage =
      true; // Biến trạng thái để kiểm soát việc hiển thị thông báo

  final List<Map<String, String>> aiAgents = [
    {
      'id': '001',
      'name': 'GPT - 3.5',
      'avatar': 'assets/gpt-35.webp',
      'tokens': '10'
    },
    {
      'id': '002',
      'name': 'GPT - 4',
      'avatar': 'assets/gpt-4.webp',
      'tokens': '100'
    },
    {
      'id': '003',
      'name': 'Claude',
      'avatar': 'assets/claude.webp',
      'tokens': '30'
    },
    {
      'id': '004',
      'name': 'Gemini',
      'avatar': 'assets/gemini.png',
      'tokens': '20'
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose(); // Dispose FocusNode
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'text': _messageController.text,
          'isUser': true,
          'timestamp': DateTime.now(),
          'avatar': 'assets/user_avatar.jpg',
        });
        // Tìm AI đã chọn trong danh sách aiAgents
        final selectedAI = aiAgents.firstWhere(
          (agent) => agent['id'] == selectedAgent,
        );

        // Lấy giá trị tokens của AI đã chọn
        final int tokensToDeduct = int.parse(selectedAI['tokens']!);

        // Trừ số token của AI đã chọn từ tổng số token hiện tại
        tokenCount = tokenCount - tokensToDeduct;

        // Lưu lại tin nhắn của người dùng để sử dụng cho phản hồi của AI
        final userMessage = _messageController.text;

        // Thêm tin nhắn phản hồi từ AI vào danh sách messages
        messages.add({
          'text': userMessage,
          'isUser': false,
          'timestamp': DateTime.now(),
          'avatar': selectedAI['avatar'],
        });

        _messageController.clear();
        _messageFocusNode.unfocus(); // Bỏ focus sau khi gửi tin nhắn
        showWelcomeMessage = false; // Ẩn thông báo khi bắt đầu chat
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Bỏ focus khi chạm vào bất kỳ đâu trên màn hình
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
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
                      selectedAgent: selectedAgent,
                      aiAgents: aiAgents,
                      onChanged: (value) {
                        setState(() {
                          selectedAgent = value!;
                        });
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                  setState(() {
                    messages.clear();
                    showWelcomeMessage =
                        true; // Hiển thị lại thông báo khi bấm "New Chat"
                  });
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
        ),
        drawer: CustomDrawer(
          onItemTap: (String) {},
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: showWelcomeMessage
                      ? const WelcomeMessage()
                      : ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message =
                                messages[messages.length - 1 - index];
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
                            itemBuilder:
                                (context, item, isDisabled, isSelected) =>
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
                            color:
                                Colors.black, // or any default color you prefer
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            focusNode: _messageFocusNode, // Sử dụng FocusNode
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
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
