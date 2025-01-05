import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/toast.dart';

import '../../prompt_bottom_sheet/prompt_bottom_sheet.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode messageFocusNode;
  final VoidCallback onSendMessage;

  const MessageInput({
    Key? key,
    required this.messageController,
    required this.messageFocusNode,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            DropdownSearch<(IconData, String)>(
              mode: Mode.custom,
              items: (f, cs) => [
                (Icons.image_outlined, 'Upload image'),
                (Icons.photo_camera_outlined, 'Take a photo'),
                (Icons.electric_bolt_outlined, 'Prompt'),
              ],
              compareFn: (item1, item2) => item1.$1 == item2.$1,
              popupProps: PopupProps.modalBottomSheet(
                fit: FlexFit.loose,
                itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Icon(item.$1, color: Colors.black),
                    title: Text(
                      item.$2,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              dropdownBuilder: (ctx, selectedItem) => const Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.black,
              ),
              onChanged: (selectedItem) {
                if (selectedItem != null) {
                  switch (selectedItem.$2) {
                    case 'Upload image':
                      ToastUtils.showToast("Coming soon");
                      break;
                    case 'Take a photo':
                      ToastUtils.showToast("Coming soon");
                      break;
                    case 'Prompt':
                      showPromptBottomSheet(context, onClick: (prompt) {
                        messageController.text = prompt.content;
                      });
                      break;
                    default:
                  }
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Center(
                // Fixed height for the text box
                child: TextField(
                  controller: messageController,
                  focusNode: messageFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  maxLines: 4,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical:
                      TextAlignVertical.center, // Center vertical alignment
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
