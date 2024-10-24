import 'package:flutter/material.dart';

import 'common_widgets.dart';

class NewPrivatePromptContent extends StatefulWidget {
  const NewPrivatePromptContent({super.key});

  @override
  State<NewPrivatePromptContent> createState() =>
      _NewPrivatePromptContentState();
}

class _NewPrivatePromptContentState extends State<NewPrivatePromptContent> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? prompt;

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
              controller: _controller,
              hintText: 'Name of the prompt',
              hintMaxLines: 2,
              onChanged: (value) {
                name = value;
              },
            ),
            const Text(
              'Prompt',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const PromptHelperCard(),
            PromptTextFormField(
              controller: _controller,
              hintText: 'e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]',
              hintMaxLines: 2,
              onChanged: (value) {
                prompt = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}