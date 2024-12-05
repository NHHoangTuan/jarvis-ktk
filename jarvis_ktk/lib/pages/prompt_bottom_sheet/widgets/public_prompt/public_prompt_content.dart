import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/prompt_list.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/public_prompt_search_bar.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import 'filter/filter_buttons.dart';

class PublicPromptContent extends StatefulWidget {
  final void Function(Prompt) onClick;
  const PublicPromptContent({super.key, required this.onClick});

  @override
  PublicPromptContentState createState() => PublicPromptContentState();
}

class PublicPromptContentState extends State<PublicPromptContent> {
  late Future<List<Prompt>> _promptsFuture;
  Timer? _debounce;
  String? _selectedCategory;
  String? _searchText;
  List<Prompt> _prompts = [];
  bool _isLoadingMore = false;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _promptsFuture = _fetchPrompts();
    _scrollController.addListener(_onScroll);
  }

  Future<List<Prompt>> _fetchPrompts({int page = 0}) async {
    return getIt<PromptApi>().getPrompts(
      isPublic: true,
      query: _searchText,
      category: _selectedCategory?.toLowerCase(),
      offset: page,
    );
  }

  void refreshPrompts() {
    setState(() {
      _promptsFuture = _fetchPrompts();
    });
  }

  void searchPrompt() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _currentPage = 1;
        _prompts = [];
        _promptsFuture = _fetchPrompts();
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMorePrompts();
    }
  }

  Future<void> _loadMorePrompts() async {
    setState(() {
      _isLoadingMore = true;
    });
    final newPrompts = await _fetchPrompts(page: _currentPage + 1);
    setState(() {
      _currentPage++;
      _prompts.addAll(newPrompts);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PublicPromptSearchBar(
            onChanged: (text) {
              _searchText = text;
              searchPrompt();
            },
          ),
          FilterButtons(onCategorySelected: (category) {
            setState(() {
              if (category == 'All') {
                _selectedCategory = null;
              } else {
                _selectedCategory = category;
              }
              searchPrompt();
            });
          }),
          FutureBuilder<List<Prompt>>(
            future: _promptsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No prompts available'));
              } else {
                _prompts = snapshot.data!
                  ..sort((a, b) {
                    if (a is PublicPrompt && b is PublicPrompt) {
                      return (b.isFavorite ? 1 : 0)
                          .compareTo(a.isFavorite ? 1 : 0);
                    }
                    return 0;
                  });
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(indent: 16.0, endIndent: 16.0),
                    controller: _scrollController,
                    itemCount: _prompts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _prompts.length) {
                        return _isLoadingMore
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      return PromptListTile(
                        anyPrompt: _prompts[index],
                        onDelete: () {
                          // Handle delete action
                        },
                        onClick: widget.onClick,
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
