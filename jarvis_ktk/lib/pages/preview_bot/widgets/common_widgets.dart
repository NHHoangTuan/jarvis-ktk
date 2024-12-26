import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';
import '../../../utils/colors.dart';
import 'unit/dialog/add_unit_content.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ResizedImage(
          imagePath: selectedDataSource.imagePath, width: 18, height: 18),
      title: Text(
        selectedDataSource.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

class TextFormTitle extends StatelessWidget {
  final String title;

  const TextFormTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final String title;
  final String content;

  const DeleteDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        SizedBox(
          width: 80,
          height: 35,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.transparent,
            ),
            onPressed: () => Navigator.of(context).pop(false), // Confirm delete
            child: const Text('Cancel',
                style: TextStyle(color: SimpleColors.blue)),
          ),
        ),
        SizedBox(
          width: 80,
          height: 35,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true), // Confirm delete
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  static Future<bool?> show(
      {required BuildContext context,
      required String title,
      required String content}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(
          title: title,
          content: content,
        );
      },
    );
  }
}
