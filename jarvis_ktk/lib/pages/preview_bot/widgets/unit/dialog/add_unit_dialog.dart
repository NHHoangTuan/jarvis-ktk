import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';

import '../../../../prompt_bottom_sheet/widgets/common_widgets.dart';
import 'add_unit_content.dart';
import 'add_unit_title.dart';
import 'data_source_dialog_content.dart';

class AddUnitDialog extends StatefulWidget {
  final String knowledgeId;
  final void Function() onClick;

  const AddUnitDialog({super.key, required this.knowledgeId, required this.onClick});

  @override
  State<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  DataSource? selectedDataSource;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  void _onSelected(DataSource dataSource) {
    selectedDataSource = dataSource;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      contentPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0),
      actionsPadding:
          const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 16),
      title: const AddUnitDialogTitle(),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: PageView(
          controller: _pageController,
          children: [
            DataSourceDialogContent(onSelected: _onSelected),
            AddUnitContent(knowledgeId: widget.knowledgeId, onConnect: widget.onClick),
          ],
        ),
      ),
      insetPadding: const EdgeInsets.all(10),
      actions: [
        if (currentPage == 0) ...[
          const CancelButton(),
          NextButton(onPressed: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }),
        ] else if (currentPage == 1) ...[
          BackButton(onPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }),
          if (selectedDataSource?.title != "Github repositories")
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Connect'),
          ),
        ],
      ],
    );
  }
}

void showAddUnitDialog(BuildContext context, String knowledgeId, void Function() onClick){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddUnitDialog(knowledgeId: knowledgeId, onClick: onClick);
    },
  );
}
