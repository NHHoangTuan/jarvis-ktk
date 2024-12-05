import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jarvis_ktk/utils/colors.dart';

import '../../../utils/resized_image.dart';

class SelectAgentDropdown extends StatelessWidget {
  final String selectedAgent;
  final List<Map<String, String>> aiAgents;
  final ValueChanged<String?> onChanged;

  const SelectAgentDropdown({
    Key? key,
    required this.selectedAgent,
    required this.aiAgents,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: false,
        selectedItemBuilder: (context) => aiAgents
            .map(
              (item) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ResizedImage(imagePath: item['avatar']!, width: 18, height: 18, isRound: true,),
                  const SizedBox(width: 6),
                  Text(
                    item['name']!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
            .toList(),
        items: aiAgents
            .map((Map<String, String> item) => DropdownMenuItem<String>(
                  value: item['id'],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResizedImage(imagePath: item['avatar']!, width: 18, height: 18, isRound: true,),
                      const SizedBox(width: 6),
                      Text(
                        item['name']!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        item['tokens']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ],
                  ),
                ))
            .toList(),
        value: selectedAgent,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 0, bottom: 0),
          decoration: BoxDecoration(
            color: SimpleColors.steelBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
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
            borderRadius: BorderRadius.circular(14),
            color: SimpleColors.lightBlue,
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
      ),
    );
  }
}
