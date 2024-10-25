import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        'Cancel',
        style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 13,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: const Color(0xFFB3A0F4),
      ),
      onPressed: onPressed,
      child: const Text(
        'Save',
        style: TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: const Color(0xFFB3A0F4),
      ),
      onPressed: onPressed,
      child: const Text(
        'Next',
        style: TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class InfoDialogTitle extends StatelessWidget {
  const InfoDialogTitle({super.key, required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          prompt,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton(
                icon: const Icon(Icons.star_border, size: 16),
                onPressed: () {
                  // Handle favorite button press
                },
              ),
            ),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}

class NewPromptDialogTitle extends StatelessWidget {
  const NewPromptDialogTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // to balance the row
        const IconButton(
          icon: Icon(Icons.close, size: 16, color: Colors.transparent),
          onPressed: null,
        ),
        const Text(
          "New Prompt",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 16),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class PromptTextFormField  extends StatefulWidget {
  final String hintText;
  final int hintMaxLines;
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const PromptTextFormField ({
    super.key,
    required this.hintText,
    required this.hintMaxLines,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<PromptTextFormField> createState() => _PromptTextFormField();

}

class _PromptTextFormField extends State<PromptTextFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: TextFormField(
        controller: _controller,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
          hintMaxLines: widget.hintMaxLines,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          contentPadding: const EdgeInsets.only(
              left: 8, top: 6, bottom: 6, right: 8),
          isDense: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.9),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

class PromptHelperCard extends StatelessWidget {
  const PromptHelperCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.blue,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        height: 27,
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F8FF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Use square brackets ',
                    style: TextStyle(fontSize: 11, color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Container(
                      transform: Matrix4.translationValues(0, 1, 0),
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      color: Colors.grey[300],
                      child: const Text(
                        '[ ]',
                        style: TextStyle(
                            fontSize: 11, color: Colors.black),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: ' to specify user input. ',
                    style: TextStyle(fontSize: 11, color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Learn More',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle "Learn More" tap
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.blue,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Container(
        height: 27,
        decoration: BoxDecoration(
          color: const Color(0xFFF0E0FF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '👑 Create a prompt, Win Monica Pro',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class PromptDropdownButton extends StatelessWidget {
  final String selectedItem;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const PromptDropdownButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( hintText,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold)),
        Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              height: 35,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.9),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white, // Background color
              ),
              child: DropdownButton<String>(
                value: selectedItem,
                isExpanded: true,
                menuMaxHeight: 200,
                underline: const SizedBox.shrink(),
                onChanged: onChanged,
                items: items
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          fontSize:
                          12), // Adjust text style if needed
                    ),
                  );
                }).toList(),
              ),
            )
        ),
      ],
    );
  }
}