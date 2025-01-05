import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/models/prompt.dart';
import '../../../data/models/user.dart';
import '../../../data/network/prompt_api.dart';
import '../../../services/service_locator.dart';

class PromptWidget extends StatefulWidget {
  final TextEditingController messageController;
  final VoidCallback onClosePromptList;
  final User? user;

  const PromptWidget({
    super.key,
    required this.messageController,
    required this.onClosePromptList,
    this.user,
  });

  @override
  PromptWidgetState createState() => PromptWidgetState();
}

class PromptWidgetState extends State<PromptWidget> {
  late Future<List<Prompt>> _promptsFuture;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _user;

  @override
  void initState() {
    super.initState();
    _initialize();
    _promptsFuture = getIt<PromptApi>().getPrompts();
  }

  Future<void> _initialize() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        _user = User.fromJson(userMap);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prompt>>(
      future: _promptsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LoadingAnimationWidget.inkDrop(
            color: Colors.blueGrey,
            size: 30,
          ));
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
          final myPrompts = filteredPrompts.whereType<MyPrompt>().toList();
          final publicPrompts =
              filteredPrompts.whereType<PublicPrompt>().toList();
          return SizedBox(
            height: 200,
            child: ListView(
              children: [
                if (myPrompts.isNotEmpty) ...[
                  const ListTile(
                    title: Text('My Prompts',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...myPrompts.map((prompt) => ListTile(
                        title: Text(prompt.title),
                        onTap: () {
                          widget.messageController.text = prompt.content;
                          widget.onClosePromptList();
                        },
                      )),
                ],
                if (publicPrompts.isNotEmpty) ...[
                  const ListTile(
                    title: Text('Public Prompts',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...publicPrompts.map((prompt) => ListTile(
                        title: Text(prompt.title),
                        onTap: () {
                          widget.messageController.text = prompt.content;
                          widget.onClosePromptList();
                        },
                      )),
                ],
              ],
            ),
          );
        }
      },
    );
  }
}
