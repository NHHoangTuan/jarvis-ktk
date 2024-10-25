import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';

class EditPreviewBotPage extends StatefulWidget {
  final VoidCallback onApply; // Thêm callback

  const EditPreviewBotPage({super.key, required this.onApply});

  @override
  // ignore: library_private_types_in_public_api
  _EditPreviewBotPageState createState() => _EditPreviewBotPageState();
}

class _EditPreviewBotPageState extends State<EditPreviewBotPage> {
  final TextEditingController _botNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _botNameCharCount = 0;
  int _descriptionCharCount = 0;

  @override
  void initState() {
    super.initState();
    _botNameController.addListener(_updateBotNameCharCount);
    _descriptionController.addListener(_updateDescriptionCharCount);
  }

  @override
  void dispose() {
    _botNameController.removeListener(_updateBotNameCharCount);
    _descriptionController.removeListener(_updateDescriptionCharCount);
    _botNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateBotNameCharCount() {
    setState(() {
      _botNameCharCount = _botNameController.text.length;
    });
  }

  void _updateDescriptionCharCount() {
    setState(() {
      _descriptionCharCount = _descriptionController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: ' Bot Name',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _botNameController,
              maxLength: 50,
              decoration: InputDecoration(
                hintText: 'Enter bot name',
                counterText: '$_botNameCharCount/50',
                filled: true,
                fillColor: Colors.white, // Set background color to white
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.black
                        .withOpacity(0.2), // Set border opacity to 0.2
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Description'),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLength: 2000,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter description',
                counterText: '$_descriptionCharCount/2000',
                filled: true,
                fillColor: Colors.white, // Set background color to white
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.black
                        .withOpacity(0.2), // Set border opacity to 0.2
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Profile Avatar'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Handle image upload
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(Icons.add_a_photo),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(
                        color: SimpleColors.navyBlue), // Add border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.onApply(); // Gọi callback khi nhấn nút Apply
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: SimpleColors.navyBlue, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
