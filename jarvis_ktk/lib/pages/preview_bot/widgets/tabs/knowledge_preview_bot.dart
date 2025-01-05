import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/preview_bot/widgets/dialog/add_knowledge_preview_bot.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../../data/providers/bot_provider.dart';

class KnowledgePreviewBotPage extends StatefulWidget {
  const KnowledgePreviewBotPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KnowledgePreviewBotPageState createState() =>
      _KnowledgePreviewBotPageState();
}

class _KnowledgePreviewBotPageState extends State<KnowledgePreviewBotPage>
    with AutomaticKeepAliveClientMixin {
  bool _isExpanded = false;
  bool _isLoading = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _handleLoadImportedKnowledges();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _handleLoadImportedKnowledges() async {
    final bot = Provider.of<BotProvider>(context, listen: false).selectedBot;
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<BotProvider>().loadImportedKnowledges(bot!.id);
    } catch (e) {
      debugPrint('Error loading imported knowledge: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDeleteImportKnowledge(
      String botId, String knowledgeId) async {
    setState(() {
      _isDeleting = true;
    });
    try {
      await context
          .read<BotProvider>()
          .deleteImportedKnowledge(botId, knowledgeId);

      // if (mounted) {
      //   context
      //       .read<KnowledgeProvider>()
      //       .invalidateCache(); // Load lại knowledge
      // }
      //_handleLoadKnowledges();
    } catch (e) {
      debugPrint('Error delete knowledges: $e');
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Add this line
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  ListTile(
                      leading: IconButton(
                        icon: Icon(_isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                      title: const Text(
                        'Knowledge',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            showBarModalBottomSheet(
                              expand: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  const AddKnowledgePreviewBot(),
                            );
                          },
                          icon: const Icon(Icons.add))),
                  if (_isExpanded) const Divider(),
                  Consumer<BotProvider>(builder: (context, botProvider, child) {
                    if (_isLoading) {
                      return Center(
                          child: LoadingAnimationWidget.flickr(
                        leftDotColor: Colors.blue,
                        rightDotColor: Colors.red,
                        size: 20,
                      ));
                    }
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _isExpanded
                          ? botProvider.importedKnowledges.length * 56.0
                          : 0.0,
                      child: _isExpanded
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Card(
                                margin: EdgeInsets
                                    .zero, // Align the card with the container
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: botProvider.importedKnowledges
                                      .map((knowledge) {
                                    return ListTile(
                                        title: Text(knowledge['knowledgeName']),
                                        leading: const Icon(
                                            Icons.visibility_outlined),
                                        trailing: IconButton(
                                          icon: _isDeleting
                                              ? const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                )
                                              : const Icon(
                                                  Icons.delete_outline),
                                          onPressed: _isDeleting
                                              ? null
                                              : () =>
                                                  _handleDeleteImportKnowledge(
                                                      botProvider
                                                          .selectedBot!.id,
                                                      knowledge['id']),
                                        ));
                                  }).toList(),
                                ),
                              ),
                            )
                          : null,
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
