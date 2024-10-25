import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/prompt_bottom_sheet.dart';

class CustomDrawer extends StatefulWidget {
  final Function(String) onItemTap;

  const CustomDrawer({super.key, required this.onItemTap});

  @override
  // ignore: library_private_types_in_public_api
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _showPersonalOptions = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: [
            // App name section
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(5.0),
              child: const ListTile(
                title: Text(
                  'ChatGPT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            // Navigation section
            ListView(
              shrinkWrap: true, // Prevents ListView from expanding infinitely
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Chat'),
                  onTap: () =>
                      widget.onItemTap('Chat'), // Send 'Chat' back to HomePage
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Personal'),
                  onTap: () {
                    setState(() {
                      _showPersonalOptions = !_showPersonalOptions;
                    });
                  }, // Toggle personal options
                ),
                if (_showPersonalOptions) ...[
                  ListTile(
                    leading: const Icon(Icons.android),
                    title: const Text('My Bot'),
                    tileColor: Colors.grey[300], // Dark background color
                    onTap: () {
                      widget.onItemTap('My Bot');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: const Text('Knowledge'),
                    tileColor: Colors.grey[300], // Dark background color
                    onTap: () => widget.onItemTap('Knowledge'),
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Reply'),
                  onTap: () =>
                      widget.onItemTap('Email Reply'), // Send 'Email Reply'
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () =>
                      showPromptBottomSheet(context), // Send 'Settings'
                ),
              ],
            ),

            const Divider(),

            // Chat history section
            Expanded(
              child: ListView.builder(
                itemCount: 20, // Number of chat history items
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.message),
                    title: Text('History $index'),
                    onTap: () {
                      Navigator.pop(context); // Close drawer on tap
                    },
                  );
                },
              ),
            ),

            const Divider(),

            // Account section
            Container(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text('Hoang Tuan'), // Account name
                onTap: () {
                  Navigator.pop(
                      context); // Action for account tap (e.g., profile view).
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
