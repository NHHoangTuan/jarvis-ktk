import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/prompt_bottom_sheet.dart';

class CustomDrawer extends StatefulWidget {
  final Function(String) onItemTap;
  final String initialSelectedItem;

  const CustomDrawer({
    super.key,
    required this.onItemTap,
    this.initialSelectedItem = 'Chat',
  });

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _showPersonalOptions = false;
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelectedItem;
    // Kiểm tra nếu mục hiện tại là "My Bot" hoặc "Knowledge" thì hiển thị các mục con của "Personal"
    if (_selectedItem == 'My Bot' || _selectedItem == 'Knowledge') {
      _showPersonalOptions = true;
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
                leading: Image(image: AssetImage('assets/logo.png')),
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
                  onTap: () {
                    setState(() {
                      _showPersonalOptions = !_showPersonalOptions;
                      _selectedItem = 'Personal';
                    });
                  },
                ),
                if (_showPersonalOptions) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: ListTile(
                      leading: const Icon(Icons.android),
                      title: const Text('My Bot'),
                      tileColor:
                          _selectedItem == 'My Bot' ? Colors.grey[300] : null,
                      onTap: () {
                        setState(() {
                          _selectedItem = 'My Bot';
                        });
                        widget.onItemTap('My Bot');
                      },
                    ),
                  ),
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
                  ),
                ],
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
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  tileColor:
                      _selectedItem == 'Settings' ? Colors.grey[300] : null,
                  onTap: () {
                    setState(() {
                      _selectedItem = 'Settings';
                      _showPersonalOptions = false;
                    });
                    showPromptBottomSheet(context);
                  },
                ),
              ],
            ),

            const Divider(),

            // Chat history section
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.message),
                    title: Text('History $index'),
                    onTap: () {
                      Navigator.pop(context);
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
                title: const Text('Hoang Tuan'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
