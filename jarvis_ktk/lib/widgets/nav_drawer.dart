import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/network/chat_api.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/services/cache_service.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/chat.dart';
import '../data/models/user.dart';
import '../data/network/api_service.dart';
import '../data/network/auth_api.dart';
import '../data/network/knowledge_api_service.dart';
import '../data/providers/token_provider.dart';
import '../services/service_locator.dart';

class NavDrawer extends StatefulWidget {
  final Function(String) onItemTap;
  final String initialSelectedItem;

  @override
  // ignore: library_private_types_in_public_api
  _NavDrawerState createState() => _NavDrawerState();
  const NavDrawer({
    super.key,
    required this.onItemTap,
    this.initialSelectedItem = 'Chat',
  });
}

class _NavDrawerState extends State<NavDrawer> with TickerProviderStateMixin {
  bool _showPersonalOptions = false;
  late String _selectedItem;
  bool _isLoadingHistory = false;
  bool _isLoadingSignOut = false;

  final chatApi = getIt<ChatApi>();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelectedItem;
    // Kiểm tra nếu mục hiện tại là "My Bot" hoặc "Knowledge" thì hiển thị các mục con của "Personal"
    if (_selectedItem == 'My Bot' || _selectedItem == 'Knowledge') {
      _showPersonalOptions = true;
    }
    Future.microtask(() {
      _handleLoadConversations();
    });
  }

  // Handle login
  Future<void> _handleSignOut() async {
    setState(() {
      _isLoadingSignOut = true;
    });
    try {
      final authApi = getIt<AuthApi>();
      final response = await authApi.signOut();
      final apiService = getIt<ApiService>();
      final knowledgeApiService = getIt<KnowledgeApiService>();

      if (response.statusCode == 200) {
        await apiService.clearTokens(); // Xóa tokens
        await apiService.clearUser(); // Xóa thông tin user
        await knowledgeApiService.clearTokens(); // Xóa knowledge

        if (mounted) {
          Provider.of<ChatProvider>(context, listen: false).clearAll();
          Provider.of<TokenProvider>(context, listen: false).clearAll();
          Provider.of<BotProvider>(context, listen: false).clearAll();
        }

        CacheService.clearAllCache(); // Xóa cache
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
    } finally {
      setState(() {
        _isLoadingSignOut = false;
      });
    }
  }

  Future<void> _handleLoadConversations() async {
    setState(() {
      _isLoadingHistory = true;
    });

    final chatProvider = context.read<ChatProvider>();
    final botProvider = context.read<BotProvider>();

    try {
      if (chatProvider.isBOT) {
        if (botProvider.threads.isEmpty) {
          await botProvider.loadThreads(chatProvider.selectedAiAgent['id']!);
        }

        if (botProvider.threads.isNotEmpty) {
          final conversations = botProvider.threads
              .map((thread) => Conversation(
                    id: thread.openAiThreadId,
                    title: thread.threadName,
                    createdAt:
                        DateTime.parse(thread.createdAt).millisecondsSinceEpoch,
                  ))
              .toList();
          chatProvider.setConversations(conversations);
        } else {
          chatProvider.setConversations([]);
        }
      } else {
        await chatProvider.loadConversations(null);
      }
    } catch (e) {
      debugPrint('Error loading conversations: $e');
    } finally {
      setState(() {
        _isLoadingHistory = false;
      });
    }
  }

  void _openUpgradeLink() async {
    final Uri url = Uri.parse('https://admin.dev.jarvis.cx/pricing/overview');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
                  leading: const Icon(Icons.home_rounded),
                  title: const Text('Chat'),
                  tileColor: _selectedItem == 'Chat' ? Colors.grey[300] : null,
                  onTap: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .setTapHistory(false);
                    setState(() {
                      _selectedItem = 'Chat';
                      _showPersonalOptions = false;
                    });
                    widget.onItemTap('Chat');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: const Text('Personal'),
                  tileColor:
                      _selectedItem == 'Personal' ? Colors.grey[300] : null,
                  trailing: _showPersonalOptions
                      ? const Icon(Icons.arrow_drop_up)
                      : const Icon(Icons.arrow_drop_down),
                  onTap: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .setTapHistory(false);
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
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .setTapHistory(false);
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
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .setTapHistory(false);
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
                  leading: const Icon(Icons.email_rounded),
                  title: const Text('Email Reply'),
                  tileColor:
                      _selectedItem == 'Email Reply' ? Colors.grey[300] : null,
                  onTap: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .setTapHistory(false);
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
              child: RefreshIndicator(
                onRefresh: _handleLoadConversations,
                child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, snapshot) {
                  if (_isLoadingHistory) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (chatProvider.conversations.isEmpty) {
                    return const Center(
                      child: Text('No conversations found.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: chatProvider.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = chatProvider.conversations[index];
                      return ListTile(
                        leading: const Icon(Icons.message),
                        title: Text(conversation.title),
                        onTap: () {
                          chatProvider.selectConversationId(
                              conversation.id); // Set selected conversation
                          chatProvider.setTapHistory(true);
                          setState(() {
                            _selectedItem = 'Chat';
                            _showPersonalOptions = false;
                          });
                          widget.onItemTap('Chat');
                        },
                      );
                    },
                  );
                }),
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
    final tokenProvider = Provider.of<TokenProvider>(context);

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Token Usage 🔥',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${tokenProvider.currentToken} / ${tokenProvider.tokenUsage.totalTokens}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      // Sử lí nếu value lỗi
                      value: tokenProvider.tokenUsage.totalTokens == 0
                          ? 1
                          : tokenProvider.currentToken /
                              tokenProvider.tokenUsage.totalTokens,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 16),
                    if (tokenProvider.tokenUsage.unlimited == true)
                      const SizedBox()
                    else // Nếu chưa nâng cấp lên Pro
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _openUpgradeLink();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Màu nền
                            foregroundColor: Colors.black, // Màu chữ
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),

                            elevation: 0, // Độ cao
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ResizedImage(
                                  imagePath: 'assets/upgrade.png',
                                  width: 20,
                                  height: 20), // Biểu tượng ngôi sao
                              SizedBox(width: 8),
                              Text(
                                'Upgrade to Pro',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              // Sign out button
              ListTile(
                leading: _isLoadingSignOut
                    ? LoadingAnimationWidget.inkDrop(
                        color: Colors.blueGrey, size: 30)
                    : const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: _isLoadingSignOut ? null : _handleSignOut,
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
