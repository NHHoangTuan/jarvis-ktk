import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';

import '../common_widgets.dart';

class EditMyPromptContent extends StatefulWidget {
  const EditMyPromptContent({super.key, required this.prompt});

  final MyPrompt prompt;

  @override
  State<EditMyPromptContent> createState() => _EditMyPromptContent();
}

class _EditMyPromptContent extends State<EditMyPromptContent>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OfferCard(),
            const Text('Name',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            PromptTextFormField(
              hintText: 'Name of the prompt',
              hintMaxLines: 2,
              initialValue: widget.prompt.title,
              onChanged: (value) {
                widget.prompt.title = value;
              },
            ),
            const Text(
              'Prompt',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            PromptTextFormField(
              hintText:
                  'e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]',
              hintMaxLines: 2,
              initialValue: widget.prompt.content,
              onChanged: (value) {
                widget.prompt.content = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditMyPromptTitle extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String prompt;

  const EditMyPromptTitle({super.key, required this.prompt})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(prompt,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(
            height: 32,
            width: 32,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconSize: 16,
            ),
          ),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
  }
}
