import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jarvis_ktk/pages/chat/widgets/add_custom_assistant.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/bot_provider.dart';
import '../../../data/providers/chat_provider.dart';
import '../../../utils/resized_image.dart';

class SelectAgentDropdown extends StatefulWidget {
  const SelectAgentDropdown({
    super.key,
  });

  @override
  _SelectAgentDropdownState createState() => _SelectAgentDropdownState();
}

class _SelectAgentDropdownState extends State<SelectAgentDropdown> {
  String? _selectedAiAgentId;

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _selectedAiAgentId = chatProvider.selectedAiAgent['id'];
  }

  Future<void> _handleLoadThreads() async {
    final botProvider = Provider.of<BotProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await botProvider.loadThreads(chatProvider.selectedAiAgent['id']!);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Consumer<ChatProvider>(builder: (context, chatProvider, child) {
        return DropdownButton2<String>(
          isExpanded: true,
          selectedItemBuilder: (context) => [
            const SizedBox(),
            ...chatProvider.aiAgents.map(
              (item) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ResizedImage(
                    imagePath: item['avatar']!,
                    width: 18,
                    height: 18,
                    isRound: true,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item['name']!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          ],
          items: [
            // Thêm nút "Create Assistant" ở đầu danh sách
            const DropdownMenuItem<String>(
              value: 'create',
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.blue),
                  SizedBox(width: 6),
                  Text(
                    "Create Assistant",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...chatProvider.aiAgents
                .map((Map<String, String> item) => DropdownMenuItem<String>(
                      value: item['id'],
                      child: Row(
                        children: [
                          ResizedImage(
                            imagePath: item['avatar']!,
                            width: 18,
                            height: 18,
                            isRound: true,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item['name']!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['tokens']!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const ResizedImage(
                                  imagePath: 'assets/fire_2.png',
                                  width: 18,
                                  height: 18)
                            ],
                          ),
                        ],
                      ),
                    )),
          ],
          value: _selectedAiAgentId,
          onChanged: (value) async {
            if (value == 'create') {
              //await _handleCreateAssistant(context);
              showBarModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddCustomAssistant(),
              );
            } else {
              setState(() {
                _selectedAiAgentId = value;
              });
              final aiAgent = chatProvider.aiAgents
                  .firstWhere((element) => element['id'] == value);
              chatProvider.selectAiAgent(aiAgent);
              if (aiAgent['tokens'] == '0') {
                chatProvider.setBOT(true);
                chatProvider.clearChatHistory();
                chatProvider.selectConversationId('');
                await _handleLoadThreads();
              } else {
                chatProvider.setBOT(false);
                chatProvider.selectConversationId('');
                chatProvider.clearChatHistory();
              }
            }
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
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.navigate_next,
            ),
            iconSize: 20,
            iconEnabledColor: Colors.blue,
            iconDisabledColor: Colors.grey,
            openMenuIcon: Icon(
              Icons.expand_more,
              size: 20,
              color: Colors.blue,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.lightBlue[50],
            ),
            offset: const Offset(-20, 0),
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
