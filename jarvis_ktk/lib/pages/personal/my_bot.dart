import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ktk/pages/personal/widgets/confirm_delete_dialog.dart';
import 'package:jarvis_ktk/pages/personal/widgets/type_dropdown.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';
import 'package:provider/provider.dart';

import '../../data/models/bot.dart';
import '../../data/providers/bot_provider.dart';

class MyBotPage extends StatefulWidget {
  //final VoidCallback onApply;

  const MyBotPage({super.key});

  @override
  _MyBotPageState createState() => _MyBotPageState();
}

class _MyBotPageState extends State<MyBotPage> {
  final FocusNode _searchFocusNode = FocusNode(); // Thêm FocusNode

  bool _isLoading = false;
  bool _isLoadingFavorite = false;

  @override
  void initState() {
    super.initState();
    _handleLoadBots();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose FocusNode
    super.dispose();
  }

  Future<void> _handleLoadBots() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<BotProvider>().loadBots();
    } catch (e) {
      debugPrint('Error loading bots: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleFavoriteBot(Bot bot) async {
    setState(() {
      _isLoadingFavorite = true;
    });
    try {
      debugPrint('Favorite bot: ${bot.isFavorite}');
      dynamic data = {
        'assistantName': bot.assistantName,
        'isFavorite': !bot.isFavorite,
      };
      Provider.of<BotProvider>(context, listen: false).updateBot(bot.id, data);
    } catch (e) {
      debugPrint('Error favoriting bot: $e');
    } finally {
      setState(() {
        _isLoadingFavorite = false;
      });
    }
  }

  String formatDescription(String? description) {
    if (description == null) return '';
    // Kiểm tra vị trí của ký tự xuống dòng
    int newlineIndex = description.indexOf('\n');
    if (newlineIndex != -1) {
      return description.substring(0, newlineIndex) + '...';
    }
    return description;
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
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildDropdownButton() =>
      const Expanded(flex: 3, child: TypeDropdown());

  Widget _buildSearchField() => Expanded(
        flex: 7,
        child: TextField(
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            contentPadding: const EdgeInsets.all(8),
          ),
        ),
      );

  Widget _buildBody() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildDropdownButton(),
                const SizedBox(width: 8),
                _buildSearchField(),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = (constraints.maxWidth / 200).floor();
                return RefreshIndicator(
                  onRefresh: _handleLoadBots,
                  child: Consumer<BotProvider>(
                    builder: (context, botProvider, child) {
                      if (_isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (botProvider.bots.isEmpty) {
                        return const Center(
                          child: Text('No bots found. Create your first bot!'),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              crossAxisCount > 0 ? crossAxisCount : 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3 / 1,
                        ),
                        itemCount: botProvider.bots.length,
                        itemBuilder: (context, index) {
                          return _buildGridItem(botProvider.bots[index]);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );

  Widget _buildGridItem(Bot bot) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.grey, width: 0.25)),
        child: InkWell(
          onTap: () {
            context.read<BotProvider>().selectBot(bot);
            Navigator.pushNamed(context, '/previewbot');
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: ResizedImage(
                    imagePath: 'assets/chatbot.png',
                    height: 80,
                    width: 80,
                    isRound: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bot.assistantName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(formatDescription(bot.description),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                    icon: bot.isFavorite
                                        ? const Icon(Icons.star,
                                            color: Colors.yellow)
                                        : const Icon(Icons.star_outline),
                                    onPressed: () => _isLoadingFavorite
                                        ? null
                                        : _handleFavoriteBot(bot)),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => ConfirmDeleteDialog.show(
                                      context: context,
                                      title: "Confirm",
                                      content:
                                          "Are you sure you want to delete this assistant? This action cannot be undone.",
                                      onDelete: () => context
                                          .read<BotProvider>()
                                          .deleteBot(bot.id),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Icon(Icons.schedule,
                                  color: Colors.grey, size: 16),
                              const SizedBox(width: 4),
                              Text(formatDate(bot.createdAt),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ))
                //const SizedBox(width: 8),
              ],
            ),
          ),
        ));
  }
}
