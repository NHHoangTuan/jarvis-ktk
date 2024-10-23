import 'package:flutter/material.dart';
import 'filter_chip.dart';
import 'filter_toggle_button.dart';

enum FilterType {
  All,
  Marketing,
  AIPainting,
  Chatbot,
  SEO,
  Writing,
  More1,
  More2,
  More3,
}

class FilterButtons extends StatefulWidget {
  const FilterButtons({super.key});

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
          double chipSpacing = 8.0; // space between chips
          double chipPadding = 8.0; // space inside the chip itself
          double iconWidth = 40.0; // width of the icon button

          List<FilterType> allFilters = FilterType.values;
          List<String> dropdownFilters = [];

          // Calculate how many chips fit in the row
          double currentRowWidth = 0;
          List<String> filtersToDisplay = [];

          for (var filter in allFilters) {
            String filterText = filter.toString().split('.').last;

            // Estimate width for each chip's text
            double textWidth = filterText.length * 8.0; // Simple estimate based on average char width
            double totalChipWidth = textWidth + chipPadding * 2;

            // Check if adding this filter exceeds available width
            if (currentRowWidth + totalChipWidth + chipSpacing + iconWidth < availableWidth) {
              filtersToDisplay.add(filterText);
              currentRowWidth += totalChipWidth + chipSpacing;
            } else {
              dropdownFilters.add(filterText); // Add to dropdown if it doesn't fit
            }
          }

          // Determine how many filters to show
          List<String> filtersToShow = showMoreFilters
              ? allFilters.map((e) => e.toString().split('.').last).toList()
              : filtersToDisplay;


          return Column(
            children: [
              Wrap(
                spacing: chipSpacing,
                children: [
                  // Create FilterChip for each visible filter
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
                        });
                      },
                    );
                  }),
                  // Toggle button for "More" or "Less"
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
    // Handle 'All' filter selection
    if (selectedFilter == FilterType.All) {
      if (isSelected) {
        filteredItems.addAll(FilterType.values);
      } else {
        filteredItems.clear();
      }
    } else {
      if (isSelected) {
        filteredItems.add(selectedFilter);
      } else {
        filteredItems.remove(selectedFilter);
      }

      // If any individual filter is deselected, deselect 'All'
      if (!filteredItems.contains(selectedFilter)) {
        filteredItems.remove(FilterType.All);
      }

      // If all individual filters (except 'All') are selected, select 'All'
      if (filteredItems.length == FilterType.values.length - 1 &&
          !filteredItems.contains(FilterType.All)) {
        filteredItems.add(FilterType.All);
      }
    }
  }
}
