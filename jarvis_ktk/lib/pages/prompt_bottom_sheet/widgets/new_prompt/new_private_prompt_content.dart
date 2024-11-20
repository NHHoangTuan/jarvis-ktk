import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import '../common_widgets.dart';

class NewPrivatePromptContent extends StatefulWidget {
  final Function(Prompt) onPromptChanged;

  const NewPrivatePromptContent({super.key, required this.onPromptChanged});

  @override
  State<NewPrivatePromptContent> createState() => _NewPrivatePromptContentState();
}

class _NewPrivatePromptContentState extends State<NewPrivatePromptContent> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? prompt;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePrompt() {
    final newPrompt = MyPrompt(title: name!, content: prompt!);
    widget.onPromptChanged(newPrompt);
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
            const Text('Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            PromptTextFormField(
              hintText: 'Name of the prompt',
              hintMaxLines: 2,
              onChanged: (value) {
                name = value;
                _updatePrompt();
              },
            ),
            const Text('Prompt', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const PromptHelperCard(),
            PromptTextFormField(
              hintText: 'e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]',
              hintMaxLines: 2,
              onChanged: (value) {
                prompt = value;
                _updatePrompt();
              },
            ),
          ],
        ),
      ),
    );
  }
}