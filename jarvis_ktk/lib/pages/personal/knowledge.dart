import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/pages/personal/widgets/add_knowledge_dialog.dart';
import 'package:jarvis_ktk/pages/personal/widgets/empty_knowledge_screen.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:jarvis_ktk/utils/colors.dart';

import 'widgets/knowledge_list.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  late Future<List<Knowledge>> _knowledgeFuture;
  Timer? _debounce;
  String? _searchText;
  List<Knowledge> _knowledgeList = [];
  bool _isLoadingMore = false;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _knowledgeFuture = _fetchKnowledge();
    _scrollController.addListener(_onScroll);
  }

  Future<List<Knowledge>> _fetchKnowledge({int page = 0}) async {
    return getIt<KnowledgeApi>().getKnowledgeList(
      query: _searchText,
      offset: page,
    );
  }

  void refreshKnowledge() {
    setState(() {
      _knowledgeFuture = _fetchKnowledge();
    });
  }

  void searchKnowledge() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _currentPage = 1;
        _knowledgeList = [];
        _knowledgeFuture = _fetchKnowledge();
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      _loadMoreKnowledge();
    }
  }

  Future<void> _loadMoreKnowledge() async {
    setState(() {
      _isLoadingMore = true;
    });
    final newKnowledge = await _fetchKnowledge(page: _currentPage + 1);
    setState(() {
      _currentPage++;
      _knowledgeList.addAll(newKnowledge);
      _isLoadingMore = false;
    });
  }

  void _showCreateKnowledgeDialog() {
    showAddKnowledgeDialog(context, refreshKnowledge);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          actions: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        onChanged: (value) {
                          _searchText = value;
                          searchKnowledge();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                      child: TextButton.icon(
                        onPressed: _showCreateKnowledgeDialog,
                        icon: const Icon(Icons.add_circle_outlined),
                        label: const Text('Add Knowledge',
                            style: TextStyle(fontSize: 12.0)),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: SimpleColors.navyBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Knowledge>>(
          future: _knowledgeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: EmptyKnowledgeScreen());
            } else {
              _knowledgeList = snapshot.data!;
              return KnowledgeList(knowledgeList: _knowledgeList);
            }
          },
        ),
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

class SearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const SearchBar({super.key, this.onChanged});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        focusNode: _focusNode,
        style: const TextStyle(fontSize: 14.0, height: 1),
        autofocus: false,
        showCursor: true,
        decoration: InputDecoration(
          hintText: 'Search',
          fillColor: Colors.cyan[100],
          filled: true,
          hintStyle: TextStyle(color: Colors.cyan[400]),
          prefixIcon: const Icon(
            Icons.search,
            size: 25,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              if (widget.onChanged != null) {
                widget.onChanged!('');
              }
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
      ),
    );
  }
}
