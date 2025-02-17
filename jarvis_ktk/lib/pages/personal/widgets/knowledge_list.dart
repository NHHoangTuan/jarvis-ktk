import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/main.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/common_widgets.dart';
import 'package:jarvis_ktk/routes/app_routes.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import 'knowledge_list_tile.dart';

class KnowledgeList extends StatefulWidget {
  final List<Knowledge> knowledgeList;

  const KnowledgeList({
    super.key,
    required this.knowledgeList,
  });

  @override
  State<KnowledgeList> createState() => _KnowledgeListState();
}

class _KnowledgeListState extends State<KnowledgeList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final List<Knowledge> _knowledgeList;

  void _onKnowledgeTap(Knowledge knowledge) {
    navigatorKey.currentState!.pushNamed(
      AppRoutes.knowledgeInfo,
      arguments: knowledge,
    );
  }

  @override
  void initState() {
    super.initState();
    _knowledgeList = widget.knowledgeList;
    _knowledgeList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }
  

  void _deleteKnowledge(Knowledge knowledge) async {
    final int index = _knowledgeList.indexOf(knowledge);

    if (index >= 0) {
      bool? confirmDelete = await DeleteDialog.show(
        context: context,
        title: 'Delete Knowledge',
        content:
            'Are you sure you want to delete this knowledge? This action cannot be undone.',
      );

      if (confirmDelete == true) {
        setState(() {
          try {
            getIt<KnowledgeApi>()
                .deleteKnowledge(_knowledgeList[index].id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Knowledge deleted'),
              ),
            );
          } catch (e) {
            // snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to delete unit'),
              ),
            );
            return;
          }
          Navigator.of(context).pop();
          _knowledgeList.removeAt(index);
          _listKey.currentState?.removeItem(
            index,
            (context, animation) => SizeTransition(
              sizeFactor: animation,
              child: Column(
                children: [
                  KnowledgeListTile(
                    knowledge: knowledge,
                    onDelete: () => {},
                    onAllUnitsTap: _onKnowledgeTap,
                  )
                ],
              ),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        key: _listKey,
        initialItemCount: _knowledgeList.length,
        itemBuilder: (context, index, animation) {
          final item = _knowledgeList[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Column(
              children: [
                KnowledgeListTile(
                  knowledge: item,
                  onDelete: () => _deleteKnowledge(item),
                  onAllUnitsTap: _onKnowledgeTap,
                )
              ],
            ),
          );
        });
  }
}
