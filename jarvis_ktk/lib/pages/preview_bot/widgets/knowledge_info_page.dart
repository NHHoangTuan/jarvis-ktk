import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'unit/dialog/add_unit_dialog.dart';
import 'unit/info/empty_unit_screen.dart';
import 'unit/info/unit_list.dart';

class KnowledgeInfoPage extends StatefulWidget {
  final Knowledge knowledge;

  const KnowledgeInfoPage({super.key, required this.knowledge});

  @override
  State<KnowledgeInfoPage> createState() => _KnowledgeInfoPageState();
}

class _KnowledgeInfoPageState extends State<KnowledgeInfoPage> {
  late Future<List<Unit>> _unitList;

  @override
  void initState() {
    super.initState();
    _unitList = getIt<KnowledgeApi>().getUnitList(widget.knowledge.id);
  }

  void _onUnitOperation() {
    setState(() {
      _unitList = getIt<KnowledgeApi>().getUnitList(widget.knowledge.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KnowledgeInfoAppBar(
        title: widget.knowledge.knowledgeName,
        knowledgeId: widget.knowledge.id,
        onClick: _onUnitOperation,
      ),
      body: FutureBuilder<List<Unit>>(
        future: _unitList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.inkDrop(
              color: Colors.blueGrey,
              size: 40,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyUnitScreen();
          } else {
            return UnitList(
                knowledgeId: widget.knowledge.id,
                unitList: snapshot.data!,
            );
          }
        },
      ),
    );
  }
}

class KnowledgeInfoAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final void Function() onClick;
  final String knowledgeId;

  @override
  final Size preferredSize;

  const KnowledgeInfoAppBar(
      {super.key,
      required this.title,
      required this.onClick,
      required this.knowledgeId})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(
            width: 80,
            height: 25,
            child: TextButton.icon(
              onPressed: () => showAddUnitDialog(context, knowledgeId, onClick),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(
                Icons.add_circle_outline,
                size: 12,
                color: Colors.white,
              ),
              label: const Text(
                'Add unit',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
