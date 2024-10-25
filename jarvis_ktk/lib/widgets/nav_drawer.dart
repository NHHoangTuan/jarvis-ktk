import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NavDrawer extends StatefulWidget {
  final Function(String) onItemTap;

  const NavDrawer({super.key, required this.onItemTap});

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer>
    with TickerProviderStateMixin {
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Chat'),
                  onTap: () => widget.onItemTap('Chat'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Personal'),
                  trailing: _showPersonalOptions
                      ? const Icon(Icons.arrow_drop_up)
                      : const Icon(Icons.arrow_drop_down),
                  onTap: () {
                    setState(() {
                      _showPersonalOptions = !_showPersonalOptions;
                    });
                  }, // Toggle personal options
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
                          ListTile(
                            leading: const Icon(Icons.android),
                            title: const Text('My Bot'),
                            tileColor: Colors.grey[300],
                            onTap: () {
                              widget.onItemTap('My Bot');
                            },
                          ).animate().slide().fadeIn(),
                          ListTile(
                            leading: const Icon(Icons.book),
                            title: const Text('Knowledge'),
                            tileColor: Colors.grey[300],
                            onTap: () => widget.onItemTap('Knowledge'),
                          ).animate().slide().fadeIn(),
                        ],
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Reply'),
                  onTap: () => widget.onItemTap('Email Reply'),
                ),
              ],
            ),

            const Divider(),

            // Chat history section
            Expanded(
              child: ListView.builder(
                itemCount: 20,
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
