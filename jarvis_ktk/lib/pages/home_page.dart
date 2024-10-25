import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/email_reply/email_reply_page.dart';
import 'package:jarvis_ktk/pages/personal/my_bot.dart';
import 'package:jarvis_ktk/pages/preview_bot/preview_bot.dart';
import 'package:jarvis_ktk/pages/personal/knowledge.dart';
import 'package:jarvis_ktk/pages/preview_bot/publish_bot.dart';
import 'package:jarvis_ktk/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

import 'email_reply/email_reply_app_bar.dart';
import 'chat/chat_app_bar.dart';
import 'chat/chat_body.dart';
import 'chat/chat_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable to track which screen is being displayed in the body
  Widget _currentBody = const Center(child: Text('Home Page'));
  PreferredSizeWidget _currentAppBar =
      AppBar(title: const Text('Chat with AI'));
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Correct key placement

  // Method to change the body content
  void _changeBody(Widget newBody) {
    setState(() {
      _currentBody = newBody;
    });
  }

  void _changeAppBar(PreferredSizeWidget newAppBar) {
    setState(() {
      _currentAppBar = newAppBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatModel(),
      child: Scaffold(
        key: _scaffoldKey, // Associate the Scaffold with the GlobalKey
        appBar: _currentAppBar,
        drawer: CustomDrawer(
          onItemTap: (selectedItem) {
            // Change body content based on the selected item
            switch (selectedItem) {
              case 'Chat':
                _changeBody(const Center(child: Text('Chat Page')));
                _changeAppBar(AppBar(title: const Text('Chat with AI')));
                break;
              case 'Personal':
                _changeBody(const Center(child: Text('Personal Chat')));
                _changeAppBar(AppBar(title: const Text('Personal Chat')));
                break;
              case 'Email Reply':
                _changeBody(const EmailReplyPage());
                _changeAppBar(const EmailReplyAppBar());
                break;
              case 'Settings':
                _changeBody(const Center(child: Text('Settings Page')));
                _changeAppBar(AppBar(title: const Text('Settings')));
                break;
              case 'My Bot': // Handle My Bot case
                _changeBody(MyBotPage(
                  onApply: () {
                    _changeBody(PreviewBotPage(
                      onPublish: () {
                        _changeBody(const PublishBotPage());
                        _changeAppBar(AppBar(title: const Text('Publish Bot')));
                      },
                    ));
                    _changeAppBar(AppBar(title: const Text('Preview Bot')));
                  },
                ));
                _changeAppBar(AppBar(title: const Text('My Bot')));
                break;
              case 'Knowledge': // Handle Knowledge case
                _changeBody(const KnowledgePage());
                _changeAppBar(AppBar(title: const Text('Knowledge')));
                break;
            }
            Navigator.pop(context); // Close the drawer after selecting an item
          },
        ),
        body: Stack(
          children: [
            _currentBody, // Display the currently selected body content
            // Swipe area to open drawer
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  _scaffoldKey.currentState!.openDrawer();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
