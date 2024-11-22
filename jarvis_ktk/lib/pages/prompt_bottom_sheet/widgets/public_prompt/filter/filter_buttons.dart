import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'filter_chip.dart';
import 'filter_toggle_button.dart';

enum FilterType {
  All,
  Marketing,
  Business,
  SEO,
  Writing,
  Coding,
  Career,
  Chatbot,
  Education,
  Fun,
  Productivity,
  Other
}

class FilterButtons extends StatefulWidget {
  final Function(String?) onCategorySelected;

  const FilterButtons({super.key, required this.onCategorySelected});

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  Set<FilterType> filteredItems = <FilterType>{};
  bool showMoreFilters = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          double chipSpacing = 8.0;
          double chipPadding = 8.0;
          double iconWidth = 40.0;

          List<FilterType> allFilters = FilterType.values;
          List<String> dropdownFilters = [];

          double currentRowWidth = 0;
          List<String> filtersToDisplay = [];

          for (var filter in allFilters) {
            String filterText = filter.toString().split('.').last;
            double textWidth = filterText.length * 8.0;
            double totalChipWidth = textWidth + chipPadding * 2;

            if (currentRowWidth + totalChipWidth + chipSpacing + iconWidth < availableWidth) {
              filtersToDisplay.add(filterText);
              currentRowWidth += totalChipWidth + chipSpacing;
            } else {
              dropdownFilters.add(filterText);
            }
          }

          List<String> filtersToShow = showMoreFilters
              ? allFilters.map((e) => e.toString().split('.').last).toList()
              : filtersToDisplay;

          return Column(
            children: [
              Wrap(
                spacing: chipSpacing,
                children: [
                  ...filtersToShow.map((filter) {
                    return FilterChipWidget(
                      filter: filter,
                      isSelected: filteredItems.contains(
                        FilterType.values.firstWhere(
                              (element) => element.toString().split('.').last == filter,
                        ),
                      ),
                      onSelected: (isSelected) {
                        setState(() {
                          FilterType selectedFilter = FilterType.values.firstWhere(
                                (element) => element.toString().split('.').last == filter,
                          );
                          _handleFilterSelection(selectedFilter, isSelected);
                          widget.onCategorySelected(isSelected ? filter : null);
                        });
                      },
                    ).animate().fade().scale();
                  }),
                  FilterToggleButton(
                    showMoreFilters: showMoreFilters,
                    onToggle: () {
                      setState(() {
                        showMoreFilters = !showMoreFilters;
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleFilterSelection(FilterType selectedFilter, bool isSelected) {
    if (selectedFilter == FilterType.All) {
      if (isSelected) {
        filteredItems.addAll(FilterType.values);
      } else {
        filteredItems.clear();
      }
    } else {
      filteredItems.clear();
      if (isSelected) {
        filteredItems.add(selectedFilter);
      } else {
        filteredItems.remove(selectedFilter);
      }

      if (!filteredItems.contains(selectedFilter)) {
        filteredItems.remove(FilterType.All);
      }

      if (filteredItems.length == FilterType.values.length - 1 &&
          !filteredItems.contains(FilterType.All)) {
        filteredItems.add(FilterType.All);
      }
    }
  }
}