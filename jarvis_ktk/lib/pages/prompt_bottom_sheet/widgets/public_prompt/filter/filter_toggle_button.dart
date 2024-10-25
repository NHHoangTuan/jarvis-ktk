import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FilterToggleButton extends StatelessWidget {
  final bool showMoreFilters;
  final VoidCallback onToggle;

  const FilterToggleButton({
    required this.showMoreFilters,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(showMoreFilters ? Icons.arrow_drop_up : Icons.arrow_drop_down),
      onPressed: onToggle,
    ).animate().fade().scale();
  }
}
