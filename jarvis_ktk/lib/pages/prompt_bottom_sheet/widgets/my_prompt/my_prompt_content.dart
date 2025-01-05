import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/my_prompt/expansion_tile_box.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../data/models/user.dart';
import '../prompt_list.dart';
import '../public_prompt/prompt_search_bar.dart';

class MyPromptContent extends StatefulWidget {
  final void Function(Prompt) onClick;

  const MyPromptContent({super.key, required this.onClick});

  @override
  MyPromptContentState createState() => MyPromptContentState();
}

class MyPromptContentState extends State<MyPromptContent> {
  late Future<List<Prompt>> _promptsFuture;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _user;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _promptsFuture = getIt<PromptApi>().getPrompts();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
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

  void refreshPrompts() {
    setState(() {
      _promptsFuture = getIt<PromptApi>().getPrompts();
    });
  }

  List<Prompt> _filterPrompts(List<Prompt> prompts) {
    if (_searchText.isEmpty) {
      return prompts;
    }
    return prompts.where((prompt) {
      return prompt.title.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PromptSearchBar(
            onChanged: (text) {
              if (_searchFocusNode.hasFocus) {
                setState(() {
                  _searchText = text;
                });
              }
            },
            controller: _searchController,
          ),
          Expanded(
            child: FutureBuilder<List<Prompt>>(
              future: _promptsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LoadingAnimationWidget.inkDrop(
                    color: Colors.blueGrey,
                    size: 40,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No prompts available'));
                } else {
                  final prompts = _filterPrompts(snapshot.data!);
                  final filteredPrompts = prompts.where((prompt) {
                    if (prompt is PublicPrompt) {
                      return prompt.isFavorite || prompt.userId == _user?.id;
                    }
                    return true;
                  }).toList();
                  final myPrompts = filteredPrompts.whereType<MyPrompt>().toList();
                  final publicPrompts = filteredPrompts.whereType<PublicPrompt>().toList();

                  return ListView(
                    children: [
                      PromptExpansionTileBox(
                        text: 'My Prompts',
                        promptListTiles: myPrompts.map((prompt) {
                          return PromptListTile(
                            anyPrompt: prompt,
                            onDelete: refreshPrompts,
                            onClick: widget.onClick,
                          );
                        }).toList(),
                        color: Colors.red,
                      ),
                      PromptExpansionTileBox(
                        text: 'Public Prompts',
                        promptListTiles: publicPrompts.map((prompt) {
                          return PromptListTile(
                            anyPrompt: prompt,
                            onDelete: refreshPrompts,
                            onClick: widget.onClick,
                          );
                        }).toList(),
                        color: SimpleColors.mediumBlue,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}