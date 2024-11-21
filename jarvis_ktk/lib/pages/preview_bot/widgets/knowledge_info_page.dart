import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';

import 'unit/dialog/add_unit_dialog.dart';
import 'unit/info/empty_knowledge_screen.dart';
import 'unit/info/unit_list.dart';

class KnowledgeInfoPage extends StatefulWidget {
  final Knowledge knowledge;

  const KnowledgeInfoPage({super.key, required this.knowledge});

  @override
  State<KnowledgeInfoPage> createState() => _KnowledgeInfoPageState();
}

class _KnowledgeInfoPageState extends State<KnowledgeInfoPage> {
  late List<Unit> _unitList;

  @override
  void initState() {
    super.initState();
    _unitList = widget.knowledge.unitList;
  }

  void _onUnitDeleted() {
    setState(() {
      _unitList =
          widget.knowledge.unitList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KnowledgeInfoAppBar(
        title: widget.knowledge.title,
        onClick: () {},
      ),
      body: _unitList.isEmpty
          ? const EmptyKnowledgeScreen()
          : Expanded(
              child: UnitList(
                unitList: _unitList,
                onUnitDeleted:
                    _onUnitDeleted,
              ),
            ),
    );
  }
}

class KnowledgeInfoAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final void Function() onClick;

  @override
  final Size preferredSize;

  const KnowledgeInfoAppBar(
      {super.key, required this.title, required this.onClick})
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
              onPressed: () => showAddUnitDialog(context),
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
