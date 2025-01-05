import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:jarvis_ktk/data/providers/chat_provider.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/models/bot.dart';

class AddCustomAssistant extends StatefulWidget {
  //final List<Knowledge> knowledgeList;
  const AddCustomAssistant({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCustomAssistantState createState() => _AddCustomAssistantState();
}

class _AddCustomAssistantState extends State<AddCustomAssistant> {
  List<bool> isAdded =
      List<bool>.generate(10, (index) => false); // Example item count

  bool _isLoading = false;
  List<bool> _isLoadingButtonList = [];

  @override
  void initState() {
    super.initState();
    _handleLoadBots();
  }

  Future<void> _handleLoadBots() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<BotProvider>().loadBots();

      if (mounted) {
        _isLoadingButtonList = List.generate(
            context.read<BotProvider>().bots.length, (index) => false);
      }
    } catch (e) {
      debugPrint('Error loading bots: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAddBots(Bot bot, int index) async {
    setState(() {
      _isLoadingButtonList[index] = true;
    });
    try {
      final botProvider = context.read<BotProvider>();
      final chatProvider = context.read<ChatProvider>();

      chatProvider.addBotToAiAgents(bot);
      await botProvider.favoriteBot(bot.id);
    } catch (e) {
      debugPrint('Error add bots to AI Agents: $e');
    } finally {
      setState(() {
        _isLoadingButtonList[index] = false;
      });
    }
  }

  Future<void> _handleDeleteAddedBots(String botId, int index) async {
    setState(() {
      _isLoadingButtonList[index] = true;
    });
    try {
      final botProvider = context.read<BotProvider>();
      final chatProvider = context.read<ChatProvider>();
      chatProvider.deleteBotFromAiAgents(botId);
      await botProvider.favoriteBot(botId);
    } catch (e) {
      debugPrint('Error delete bots from AI Agents: $e');
    } finally {
      setState(() {
        _isLoadingButtonList[index] = false;
      });
    }
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
                  'Select Bot',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32.0),
                Expanded(
                  child: Consumer2<BotProvider, ChatProvider>(
                    builder: (context, botProvider, chatProvider, child) {
                      if (_isLoading) {
                        return Center(
                          child: LoadingAnimationWidget.twistingDots(
                            leftDotColor: const Color(0xFF1A1A3F),
                            rightDotColor: const Color(0xFFEA3799),
                            size: 40,
                          ),
                        );
                      }

                      if (botProvider.bots.isEmpty) {
                        return const Center(
                          child: Text('No bot found. Create your first one!'),
                        );
                      }

                      final botList = botProvider.bots;
                      final addedBots = chatProvider.aiAgents;

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
                            itemCount: botList.length,
                            itemBuilder: (context, index) {
                              final bot = botList[index];

                              final isBotAdded =
                                  addedBots.any((a) => a['id'] == bot.id);
                              //final isKnowledgeImported = false;
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
                                          child: ResizedImage(
                                              imagePath: 'assets/chatbot.png',
                                              width: 48,
                                              height: 48)), // Double the size
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(bot.assistantName,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                            Text(
                                              bot.description ??
                                                  '', // Format date
                                              style: const TextStyle(
                                                  fontSize: 12.0),
                                              maxLines: 3,
                                              overflow: TextOverflow
                                                  .ellipsis, // Reduce text size
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: isBotAdded
                                            ? FloatingActionButton.small(
                                                heroTag: null,
                                                onPressed:
                                                    _isLoadingButtonList[index]
                                                        ? null
                                                        : () {
                                                            _handleDeleteAddedBots(
                                                                bot.id, index);
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
                                                heroTag: null,
                                                onPressed:
                                                    _isLoadingButtonList[index]
                                                        ? null
                                                        : () {
                                                            _handleAddBots(
                                                                bot, index);
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
