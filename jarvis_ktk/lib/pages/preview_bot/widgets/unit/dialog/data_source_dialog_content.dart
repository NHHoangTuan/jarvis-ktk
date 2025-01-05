import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/models/data_source.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

import '../../../../../utils/colors.dart';
import 'add_unit_content.dart';

class DataSourceDialogContent extends StatefulWidget {
  final void Function(DataSource dataSource) onSelected;

  const DataSourceDialogContent({super.key, required this.onSelected});

  @override
  State<DataSourceDialogContent> createState() => _DataSourceDialogContent();
}

class _DataSourceDialogContent extends State<DataSourceDialogContent> {
  String? selectedTitle;

  @override
  void initState() {
    super.initState();
    selectedTitle = dataSourceOptions[0].title;
    widget.onSelected(dataSourceOptions[0]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...dataSourceOptions.map((DataSource dataSource) {
            return _buildOption(
              context,
              dataSource.title,
              dataSource.subtitle,
              dataSource.imagePath,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, String title, String subtitle, String imagePath) {
    bool isSelected = selectedDataSource.title == title;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? SimpleColors.blue.withOpacity(0.1)
            : Colors.transparent,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: RadioListTile<String>(
        value: title,
        groupValue: selectedDataSource.title,
        selected: isSelected,
        onChanged: (String? value) {
          setState(() {
            selectedTitle = title;
            widget.onSelected(dataSourceOptions
                .firstWhere((element) => element.title == title));
            selectedDataSource = dataSourceOptions
                .firstWhere((element) => element.title == title);
          });
        },
        title: Row(
          children: [
            ResizedImage(imagePath: imagePath, width: 24, height: 24),
            const SizedBox(width: 8),
            // Add some space between the icon and the text
            Text(title),
          ],
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}