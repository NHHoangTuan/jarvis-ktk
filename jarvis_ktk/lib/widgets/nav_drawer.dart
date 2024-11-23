import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/models/chat.dart';
import 'package:jarvis_ktk/data/network/chat_api.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

import '../data/models/user.dart';
import '../data/network/api_service.dart';
import '../data/network/auth_api.dart';
import '../services/service_locator.dart';

class NavDrawer extends StatefulWidget {
  final Function(String) onItemTap;
  final String initialSelectedItem;
  final Function(String) onHistoryTap; // Thêm callback cho lịch sử chat

  @override
  // ignore: library_private_types_in_public_api
  _NavDrawerState createState() => _NavDrawerState();
  const NavDrawer({
    super.key,
    required this.onItemTap,
    required this.onHistoryTap, // Thêm callback cho lịch sử chat
    this.initialSelectedItem = 'Chat',
  });
}

class _NavDrawerState extends State<NavDrawer> with TickerProviderStateMixin {
  bool _showPersonalOptions = false;
  late String _selectedItem;
  late Future<List<Conversation>> _conversationsFuture = Future.value([]);
  List<String> _conversationIds = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelectedItem;
    // Kiểm tra nếu mục hiện tại là "My Bot" hoặc "Knowledge" thì hiển thị các mục con của "Personal"
    if (_selectedItem == 'My Bot' || _selectedItem == 'Knowledge') {
      _showPersonalOptions = true;
    }
    _fetchUser();
  }

  // Handle login
  Future<void> _handleSignOut() async {
    try {
      final authApi = getIt<AuthApi>();
      final response = await authApi.signOut();
      final apiService = getIt<ApiService>();
      if (response.statusCode == 200) {
        await apiService.clearTokens(); // Xóa tokens
        await apiService.clearUser(); // Xóa thông tin user
        Navigator.pushNamedAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          '/',
          (route) => false, // Xóa hết stack
        );
        showToast('Sign out successful');
      } else {
        showToast('Sign out failed');
      }
    } catch (e) {
      showToast(e.toString());
    } finally {}
  }

  Future<void> _fetchUser() async {
    final apiService = getIt<ApiService>();
    final user = await apiService.getStoredUser();
    setState(() {
      _user = user;
      if (_user != null) {
        _conversationsFuture = _fetchConversations();
      }
    });
  }

  Future<List<Conversation>> _fetchConversations() async {
    final chatApi = getIt<ChatApi>();
    final conversations = await chatApi.fetchConversations(
        AssistantId.GPT_4O_MINI, AssistantModel.DIFY);
    _conversationIds = conversations.map((c) => c.id).toList();
    return conversations;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: [
            // App name section
            Container(
              color: Colors.blueGrey,
              padding: const EdgeInsets.all(5.0),
              child: const ListTile(
                leading: ResizedImage(
                    imagePath: 'assets/logo.png', width: 60, height: 60),
                title: Text(
                  'Jarvis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Navigation section
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Chat'),
                  tileColor: _selectedItem == 'Chat' ? Colors.grey[300] : null,
                  onTap: () {
                    setState(() {
                      _selectedItem = 'Chat';
                      _showPersonalOptions = false;
                    });
                    widget.onItemTap('Chat');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Personal'),
                  tileColor:
                      _selectedItem == 'Personal' ? Colors.grey[300] : null,
                  trailing: _showPersonalOptions
                      ? const Icon(Icons.arrow_drop_up)
                      : const Icon(Icons.arrow_drop_down),
                  onTap: () {
                    setState(() {
                      _showPersonalOptions = !_showPersonalOptions;
                      _selectedItem = 'Personal';
                    });
                  },
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    // You can set a minimum height to maintain space when collapsed
                    constraints: BoxConstraints(
                      minHeight: _showPersonalOptions ? 0 : 0,
                    ),
                    child: Column(
                      children: [
                        if (_showPersonalOptions) ...[
                          // Indentation

                          Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: ListTile(
                              leading: const Icon(Icons.android),
                              title: const Text('My Bot'),
                              tileColor: _selectedItem == 'My Bot'
                                  ? Colors.grey[300]
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedItem = 'My Bot';
                                });
                                widget.onItemTap('My Bot');
                              },
                            ),
                          ).animate().slide().fadeIn(),
                          Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: ListTile(
                              leading: const Icon(Icons.book),
                              title: const Text('Knowledge'),
                              tileColor: _selectedItem == 'Knowledge'
                                  ? Colors.grey[300]
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedItem = 'Knowledge';
                                });
                                widget.onItemTap('Knowledge');
                              },
                            ),
                          ).animate().slide().fadeIn(),
                        ],
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Reply'),
                  tileColor:
                      _selectedItem == 'Email Reply' ? Colors.grey[300] : null,
                  onTap: () {
                    setState(() {
                      _selectedItem = 'Email Reply';
                      _showPersonalOptions = false;
                    });
                    widget.onItemTap('Email Reply');
                  },
                ),
              ],
            ),

            const Divider(),

            // Chat history section
            Expanded(
              child: FutureBuilder<List<Conversation>>(
                future: _conversationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error loading conversations'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No conversations found'));
                  } else {
                    final conversations = snapshot.data!;
                    return ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = conversations[index];
                        return ListTile(
                          leading: const Icon(Icons.message),
                          title: Text(conversation.title),
                          onTap: () {
                            widget.onHistoryTap(_conversationIds[index]);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const Divider(),

            // Account section
            _buildAccountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    final apiService = getIt<ApiService>();

    return FutureBuilder<User?>(
      future: apiService.getStoredUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Column(
            children: [
              // User info section
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(snapshot.data!.username),
                subtitle: Text(snapshot.data!.email),
              ),
              const Divider(),
              // Sign out button
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: _handleSignOut,
              ),
            ],
          );
        }

        // Hiển thị nút đăng nhập/đăng ký
        return ListTile(
          leading: const Icon(Icons.login),
          title: const Text('Sign In / Sign Up'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/login');
          },
        );
      },
    );
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
}
