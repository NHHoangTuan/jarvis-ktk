import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jarvis_ktk/data/models/bot.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/chat_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/resized_image.dart';

class SelectBotDropdown extends StatefulWidget {
  const SelectBotDropdown({
    Key? key,
  }) : super(key: key);

  @override
  _SelectBotDropdownState createState() => _SelectBotDropdownState();
}

class _SelectBotDropdownState extends State<SelectBotDropdown> {
  Future<void> _handleLoadThreads() async {
    final botProvider = Provider.of<BotProvider>(context, listen: false);
    await botProvider.loadThreads(botProvider.selectedBot!.id);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);

    return DropdownButtonHideUnderline(
      child: Consumer<BotProvider>(builder: (context, botProvider, child) {
        return DropdownButton2<String>(
          isExpanded: true,
          selectedItemBuilder: (context) => botProvider.bots
              .map(
                (item) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ResizedImage(
                      imagePath: 'assets/chatbot.png',
                      width: 18,
                      height: 18,
                      isRound: true,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.assistantName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          items: botProvider.bots
              .map((Bot item) => DropdownMenuItem<String>(
                    value: item.assistantName,
                    child: Row(
                      children: [
                        const ResizedImage(
                          imagePath: 'assets/chatbot.png',
                          width: 18,
                          height: 18,
                          isRound: true,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.assistantName,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          value: botProvider.selectedBot?.assistantName,
          onChanged: (value) {
            setState(() {
              final bot = botProvider.bots
                  .firstWhere((bot) => bot.assistantName == value);
              botProvider.selectBot(bot);
            });

            chatProvider.clearChatHistory();
            chatProvider.selectConversationId('');
            _handleLoadThreads();
          },
          buttonStyleData: ButtonStyleData(
            width: 160,
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 0, bottom: 0),
            decoration: BoxDecoration(
              color: SimpleColors.steelBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            offset: const Offset(10, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        );
      }),
    );
  }
}
