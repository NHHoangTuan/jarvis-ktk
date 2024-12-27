import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:jarvis_ktk/data/providers/knowledge_provider.dart';
import 'package:provider/provider.dart';

class AddKnowledgePreviewBot extends StatefulWidget {
  //final List<Knowledge> knowledgeList;
  const AddKnowledgePreviewBot({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddKnowledgePreviewBotState createState() => _AddKnowledgePreviewBotState();
}

class _AddKnowledgePreviewBotState extends State<AddKnowledgePreviewBot> {
  List<bool> isAdded =
      List<bool>.generate(10, (index) => false); // Example item count

  bool _isLoading = false;
  List<bool> _isLoadingButtonList = [];
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _handleLoadKnowledges();
  }

  Future<void> _handleLoadKnowledges() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<KnowledgeProvider>().loadKnowledges();

      if (mounted) {
        _isLoadingButtonList = List.generate(
            context.read<KnowledgeProvider>().knowledges.length,
            (index) => false);
      }
    } catch (e) {
      debugPrint('Error loading knowledges: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleImportKnowledge(
      String botId, String knowledgeId, int index) async {
    setState(() {
      _isLoadingButtonList[index] = true;
    });
    try {
      await context
          .read<BotProvider>()
          .importKnowledgeToBot(botId, knowledgeId);

      if (mounted) {
        context
            .read<KnowledgeProvider>()
            .invalidateCache(); // Load lại knowledge
      }
      _handleLoadKnowledges();
    } catch (e) {
      debugPrint('Error import knowledges: $e');
    } finally {
      setState(() {
        _isLoadingButtonList[index] = false;
      });
    }
  }

  Future<void> _handleDeleteImportKnowledge(
      String botId, String knowledgeId, int index) async {
    setState(() {
      _isLoadingButtonList[index] = true;
    });
    try {
      await context
          .read<BotProvider>()
          .deleteImportedKnowledge(botId, knowledgeId);

      if (mounted) {
        context
            .read<KnowledgeProvider>()
            .invalidateCache(); // Load lại knowledge
      }
      _handleLoadKnowledges();
    } catch (e) {
      debugPrint('Error delete knowledges: $e');
    } finally {
      setState(() {
        _isLoadingButtonList[index] = false;
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  String formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Material(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Knowledge',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32.0),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: TextField(
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                        flex: 3,
                        child: FloatingActionButton.extended(
                          onPressed: () {},
                          label: const Text('Create'),
                          icon: const Icon(Icons.add_circle_outline),
                          elevation: 0,
                        )),
                  ],
                ),
                const SizedBox(height: 32.0),
                Expanded(
                  child: Consumer2<KnowledgeProvider, BotProvider>(
                    builder: (context, knowledgeProvider, botProvider, child) {
                      if (_isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (knowledgeProvider.knowledges.isEmpty) {
                        return const Center(
                          child: Text(
                              'No knowledge found. Create your first one!'),
                        );
                      }

                      final knowledgeList = knowledgeProvider.knowledges;
                      final importedKnowledges = botProvider.importedKnowledges;

                      return LayoutBuilder(builder: (context, constraints) {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, // Luôn là 1 cột
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio:
                                  3, // Điều chỉnh tỉ lệ này cho phù hợp
                            ),
                            itemCount: knowledgeList.length,
                            itemBuilder: (context, index) {
                              final knowledge = knowledgeList[index];
                              // Kiểm tra xem knowledge có trong importedKnowledges không
                              final isKnowledgeImported =
                                  importedKnowledges.any((importedKnowledge) =>
                                      importedKnowledge['id'] == knowledge.id);
                              return Card.outlined(
                                elevation: 0, // bỏ đổ bóng
                                shape: BorderDirectional(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade400,
                                      width: 0.7), // Chỉ hiển thị border dưới
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        flex: 2,
                                        child: Icon(Icons.folder, size: 48.0),
                                      ), // Double the size
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                  knowledge.knowledgeName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                children: [
                                                  Card.outlined(
                                                    color: Colors.blue.shade300
                                                        .withOpacity(
                                                            0.1), // Set background color with opacity
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      side: const BorderSide(
                                                        color: Colors.blue,
                                                        width: 0.7,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .all(
                                                          6.0), // Reduce padding
                                                      child: Text(
                                                        '${knowledge.numUnits} unit',
                                                        style: TextStyle(
                                                          fontSize:
                                                              12.0, // Reduce font size
                                                          color: Colors.blue
                                                              .shade600, // Set text color to match border color
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          4.0), // Reduce spacing
                                                  Card.outlined(
                                                    color: Colors.red.shade300
                                                        .withOpacity(
                                                            0.3), // Set background color with opacity
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      side: const BorderSide(
                                                        color: Colors.red,
                                                        width: 0.7,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .all(
                                                          6.0), // Reduce padding
                                                      child: Text(
                                                        '${knowledge.totalSize} Byte',
                                                        style: TextStyle(
                                                          fontSize:
                                                              12.0, // Reduce font size
                                                          color: Colors.red
                                                              .shade600, // Set text color to match border color
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.schedule,
                                                      size:
                                                          16.0), // Reduce icon size
                                                  const SizedBox(width: 4.0),
                                                  Text(
                                                    formatDate(knowledge
                                                        .createdAt
                                                        .toString()), // Format date
                                                    style: const TextStyle(
                                                        fontSize:
                                                            12.0), // Reduce text size
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: isKnowledgeImported
                                            ? FloatingActionButton.small(
                                                onPressed:
                                                    _isLoadingButtonList[index]
                                                        ? null
                                                        : () {
                                                            _handleDeleteImportKnowledge(
                                                                botProvider
                                                                    .selectedBot!
                                                                    .id,
                                                                knowledge.id,
                                                                index);
                                                          },
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.red.shade400,
                                                child:
                                                    _isLoadingButtonList[index]
                                                        ? const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                          )
                                                        : const Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          ),
                                              )
                                            : FloatingActionButton.small(
                                                onPressed:
                                                    _isLoadingButtonList[index]
                                                        ? null
                                                        : () {
                                                            _handleImportKnowledge(
                                                                botProvider
                                                                    .selectedBot!
                                                                    .id,
                                                                knowledge.id,
                                                                index);
                                                          },
                                                elevation: 0,
                                                child:
                                                    _isLoadingButtonList[index]
                                                        ? const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                          )
                                                        : const Icon(Icons.add),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
