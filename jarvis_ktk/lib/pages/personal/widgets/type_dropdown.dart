import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/bot_provider.dart';

class TypeDropdown extends StatefulWidget {
  const TypeDropdown({
    Key? key,
  }) : super(key: key);

  @override
  _TypeDropdownState createState() => _TypeDropdownState();
}

class _TypeDropdownState extends State<TypeDropdown> {
  final List<String> items = ['All', 'Published', 'My Favourite'];
  String? selectedValue = 'All';

  @override
  Widget build(BuildContext context) {
    final botProvider = Provider.of<BotProvider>(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          botProvider.setFilterValue(value!);
          botProvider.filterBot();
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black, width: 0.8),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }
}
