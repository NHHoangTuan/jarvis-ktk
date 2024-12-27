import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';

import '../../services/cache_service.dart';

class KnowledgeProvider with ChangeNotifier {
  final KnowledgeApi _knowledgeApi;
  List<Knowledge> _knowledges = [];
  Knowledge? _selectedKnowledge;
  bool _hasLoadedInitialData = false;

  KnowledgeProvider(this._knowledgeApi);

  List<Knowledge> get knowledges => _knowledges;
  Knowledge? get selectedKnowledge => _selectedKnowledge;

  Future<void> loadKnowledges({bool forceReload = false}) async {
    if (!_hasLoadedInitialData || forceReload) {
      _knowledges = await CacheService.getCachedKnowledges(_knowledgeApi);
      _hasLoadedInitialData = true;
      notifyListeners();
    }
  }

  void invalidateCache() {
    CacheService.invalidateKnowledgeCache();
    _hasLoadedInitialData = false;
  }

  void selectKnowledge(Knowledge knowledge) {
    _selectedKnowledge = knowledge;
    notifyListeners();
  }
}
