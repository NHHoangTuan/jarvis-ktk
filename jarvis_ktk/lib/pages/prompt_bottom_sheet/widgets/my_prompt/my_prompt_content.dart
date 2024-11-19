import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import '../../../../data/models/user.dart';
import '../prompt_list.dart';

class MyPromptContent extends StatefulWidget {
  const MyPromptContent({super.key});

  @override
  State<MyPromptContent> createState() => _MyPromptContentState();
}

class _MyPromptContentState extends State<MyPromptContent> {
  late Future<List<Prompt>> _promptsFuture;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _promptsFuture = getIt<PromptApi>().getPrompts();
  }

  Future<void> _initializeUser() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        _user = User.fromJson(userMap);
      });
    }
  }

  void _refreshPrompts() {
    setState(() {
      _promptsFuture = getIt<PromptApi>().getPrompts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Prompt>>(
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
            return ListView.separated(
              itemCount: filteredPrompts.length,
              itemBuilder: (context, index) {
                return PromptListTile(
                    anyPrompt: filteredPrompts[index],
                    onDelete: _refreshPrompts);
              },
              separatorBuilder: (context, index) =>
                  const Divider(indent: 16.0, endIndent: 16.0),
            );
          }
        },
      ),
    );
  }
}
