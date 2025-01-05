import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';

import '../../services/cache_service.dart';

class KnowledgeProvider with ChangeNotifier {
  final KnowledgeApi _knowledgeApi;
  List<Knowledge> _knowledges = [];
  List<Knowledge> _filterKnowledges = [];
  Knowledge? _selectedKnowledge;
  bool _hasLoadedInitialData = false;
  String _searchText = '';

  KnowledgeProvider(this._knowledgeApi);

  List<Knowledge> get knowledges => _knowledges;
  List<Knowledge> get filterKnowledges => _filterKnowledges;
  Knowledge? get selectedKnowledge => _selectedKnowledge;
  String get searchText => _searchText;

  Future<void> loadKnowledges({bool forceReload = false}) async {
    if (!_hasLoadedInitialData || forceReload) {
      _knowledges = await CacheService.getCachedKnowledges(_knowledgeApi);
      _filterKnowledges = _knowledges.toList();
      _hasLoadedInitialData = true;
      notifyListeners();
    }
  }

  void invalidateCache() {
    CacheService.invalidateKnowledgeCache();
    _hasLoadedInitialData = false;
  }

  void filterKnowledge() {
    _filterKnowledges = _knowledges.toList();

    _filterKnowledges = _filterKnowledges
        .where((x) =>
            x.knowledgeName.toLowerCase().contains(_searchText.toLowerCase()) ||
            (x.description.toLowerCase()).contains(_searchText.toLowerCase()))
        .toList();

    notifyListeners();
  }

  void selectKnowledge(Knowledge knowledge) {
    _selectedKnowledge = knowledge;
    notifyListeners();
  }

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }
}
