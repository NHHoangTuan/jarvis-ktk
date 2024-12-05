import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/prompt_list.dart';
import 'package:jarvis_ktk/utils/colors.dart';

class PromptExpansionTileBox extends StatefulWidget {
  final String text;
  final List<PromptListTile> promptListTiles;
  final Color color;

  const PromptExpansionTileBox(
      {super.key, required this.text, required this.promptListTiles, required this.color});

  @override
  State<PromptExpansionTileBox> createState() => _PromptExpansionTileBox();
}

class _PromptExpansionTileBox extends State<PromptExpansionTileBox> {
  List<Column> listsWidget() {
    return List.generate(widget.promptListTiles.length, (index) {
      return Column(
        children: [
          widget.promptListTiles[index],
          if (index < widget.promptListTiles.length - 1)
            const Divider(indent: 16.0, endIndent: 16.0),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: const [0.04, 0.04], colors: [widget.color, Colors.white]),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Colors.red)),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(widget.text,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: SimpleColors.steelBlue)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15))),
            collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15))),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: listsWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
