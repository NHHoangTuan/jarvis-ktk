import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import '../../common_widgets.dart';
import 'unit_list_tile.dart';

class UnitList extends StatefulWidget {
  final String knowledgeId;
  final List<Unit> unitList;
  final VoidCallback onUnitAction;

  const UnitList(
      {super.key,
      required this.unitList,
      required this.onUnitAction,
      required this.knowledgeId});

  @override
  State<UnitList> createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> {
  late List<Unit> _unitList;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _unitList = widget.unitList;
  }

  void _deleteUnit(Unit unit) async {
    final int index = _unitList.indexOf(unit);

    if (index >= 0) {
      bool? confirmDelete = await DeleteDialog.show(
        context: context,
        title: 'Delete Unit',
        content:
            'Are you sure you want to delete this unit? This action cannot be undone.',
      );

      if (confirmDelete == true) {
        setState(() {
          try {
            getIt<KnowledgeApi>().deleteUnit(widget.knowledgeId, unit.id);
          } catch (e) {
            Fluttertoast.showToast(msg: 'Failed to delete unit');
            return;
          }
          _unitList.removeAt(index);
          _listKey.currentState?.removeItem(
            index,
            (context, animation) => SizeTransition(
              sizeFactor: animation,
              child: Column(
                children: [
                  UnitListTile(
                      unit: unit,
                      onDelete: () {},
                      onToggleEnabled: (newValue) {}),
                  const Divider(indent: 16.0, endIndent: 16.0),
                ],
              ),
            ),
          );
        });
      }
    }
  }

  void _toggleUnitEnabled(Unit unit, bool newValue) {
    setState(() {
      try {
        getIt<KnowledgeApi>().updateUnitStatus(unit.id, newValue);
        widget.onUnitAction();
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to update unit status');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _unitList.length,
      itemBuilder: (context, index, animation) {
        final item = _unitList[index];
        return SizeTransition(
          sizeFactor: animation,
          child: Column(
            children: [
              UnitListTile(
                unit: item,
                onDelete: () => _deleteUnit(item),
                onToggleEnabled: (newValue) =>
                    _toggleUnitEnabled(item, newValue),
              ),
              const Divider(indent: 16.0, endIndent: 16.0),
            ],
          ),
        );
      },
    );
  }
}
