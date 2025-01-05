import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/unit/dialog/connect_dialog_base.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../prompt_bottom_sheet/widgets/common_widgets.dart';
import 'add_unit_content.dart';
import 'add_unit_title.dart';
import 'data_source_dialog_content.dart';

class AddUnitDialog extends StatefulWidget {
  final String knowledgeId;
  final void Function() onClick;

  const AddUnitDialog(
      {super.key, required this.knowledgeId, required this.onClick});

  @override
  State<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  DataSource? selectedDataSource;
  final GlobalKey<ConnectDialogBaseState> connectDialogKey =
      GlobalKey<ConnectDialogBaseState>();
  bool _isLoading = false;

  void onConnect(DataSourceType type, Map<String, dynamic> fields) async {
    try {
      setState(() {
        _isLoading = true;
      });
      switch (type) {
        case DataSourceType.local_file:
          await getIt<KnowledgeApi>()
              .uploadLocalFile(widget.knowledgeId, fields['selectedFile']);
          break;
        case DataSourceType.web:
          await getIt<KnowledgeApi>().uploadFromWebsite(
              widget.knowledgeId, fields['unitName'], fields['webUrl']);
          break;
        case DataSourceType.slack:
          await getIt<KnowledgeApi>().uploadFromSlack(
            widget.knowledgeId,
            fields['unitName'],
            fields['slackWorkspace'],
            fields['slackBotToken'],
          );
          break;
        case DataSourceType.confluence:
          await getIt<KnowledgeApi>().uploadFromConfluence(
            widget.knowledgeId,
            fields['unitName'],
            fields['wikiPageUrl'],
            fields['confluenceUsername'],
            fields['confluenceAccessToken'],
          );
          break;
        case DataSourceType.google_drive:
          // await getIt<KnowledgeApi>().uploadFromGoogleDrive(widget.knowledgeId, fields['googleDriveUrl']);
          break;
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, e.toString());
      return;
    }
    setState(() {
      _isLoading = false;
    });
    widget.onClick();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

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
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      title: const AddUnitDialogTitle(),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: _isLoading
            ? Center(
                child: LoadingAnimationWidget.inkDrop(
                color: Colors.blueGrey,
                size: 40,
              ))
            : PageView(
                controller: _pageController,
                children: [
                  DataSourceDialogContent(
                      onSelected: _onSelected,
                      key: const PageStorageKey('DataSourceDialogContent')),
                  AddUnitContent(
                      connectDialogKey: connectDialogKey,
                      key: const PageStorageKey('AddUnitContent')),
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
              onPressed: _isLoading
                  ? null
                  : () {
                if (selectedDataSource == null) {
                  showSnackBar(context, 'Please select a data source');
                  return;
                }
                if (connectDialogKey.currentState!.fieldValues.isEmpty ||
                    connectDialogKey.currentState!.fieldValues.values
                        .any((element) => element == null)) {
                  showSnackBar(context, 'Please fill all fields');
                  return;
                }
                onConnect(selectedDataSource!.type,
                    connectDialogKey.currentState!.fieldValues);
              },
              child: const Text('Connect'),
            ),
        ],
      ],
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

void showAddUnitDialog(
    BuildContext context, String knowledgeId, void Function() onClick) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddUnitDialog(knowledgeId: knowledgeId, onClick: onClick);
    },
  );
}
