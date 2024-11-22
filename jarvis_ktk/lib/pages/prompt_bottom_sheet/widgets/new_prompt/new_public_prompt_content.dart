import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/filter/filter_buttons.dart';
import '../common_widgets.dart';

const Set<String> languagesList = <String>{'English', 'Spanish', 'French'};
List<String> categoriesList = FilterType.values
    .map((e) => e.toString().split('.').last)
    .toList();

class NewPublicPromptContent extends StatefulWidget {
  final Function(Prompt) onPromptChanged;

  const NewPublicPromptContent({super.key, required this.onPromptChanged});

  @override
  State<NewPublicPromptContent> createState() => _NewPublicPromptContentState();
}

class _NewPublicPromptContentState extends State<NewPublicPromptContent> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? prompt;
  String? category = categoriesList.first.toLowerCase();
  String? description;
  String? language = languagesList.first;

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePrompt() {
    final newPrompt = PublicPrompt(
      title: name != null? name! : '',
      content: prompt != null? prompt! : '',
      category: category == "all" ? null : category!,
      description: description,
      language: language,
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PromptDropdownButton(
                  items: languagesList.toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      language = newValue!;
                      _updatePrompt();
                    });
                  },
                  hintText: 'Prompt Language',
                  selectedItem: language!,
                ),
                PromptDropdownButton(
                  items: categoriesList.toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      category = newValue!.toLowerCase();
                      _updatePrompt();
                    });
                  },
                  hintText: 'Category',
                  selectedItem: category!.toTitleCase(),
                ),
                const Text('Placeholder', style: TextStyle(fontSize: 1, color: Colors.transparent)),
              ],
            ),
            const Text('Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            PromptTextFormField(
              hintText: 'Name of the prompt',
              hintMaxLines: 1,
              onChanged: (value) {
                name = value;
                _updatePrompt();
              },
            ),
            const Text('Description (Optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            PromptTextFormField(
              hintText: 'Describe your prompt so others can have a better understanding',
              hintMaxLines: 2,
              onChanged: (value) {
                description = value;
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

extension on String {
  String toTitleCase() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}