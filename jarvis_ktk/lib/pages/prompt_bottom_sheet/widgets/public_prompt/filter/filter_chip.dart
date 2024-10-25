import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String filter;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const FilterChipWidget({
    required this.filter,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(filter),
      key: ValueKey(filter),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.grey[100],
      selected: isSelected,
      selectedColor: Colors.black,
      labelStyle: TextStyle(
        fontSize: 10,
        color: isSelected ? Colors.white : Colors.black,
      ),
      showCheckmark: false,
      onSelected: onSelected,
    );
  }
}
