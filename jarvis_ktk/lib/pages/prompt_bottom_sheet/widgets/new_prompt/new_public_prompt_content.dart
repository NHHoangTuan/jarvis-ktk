import 'package:flutter/material.dart';

import '../common_widgets.dart';

const Set<String> languagesList = <String>{'English', 'Spanish', 'French'};
const Set<String> categoriesList = <String>{
  'Writing',
  'Design',
  'Development',
  'Other'
};

class NewPublicPromptContent extends StatefulWidget {
  const NewPublicPromptContent({super.key});

  @override
  State<NewPublicPromptContent> createState() => _NewPublicPromptContentState();
}

class _NewPublicPromptContentState extends State<NewPublicPromptContent>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? prompt;
  String? category = categoriesList.first;
  String? description;
  String? language = languagesList.first;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PromptDropdownButton(
                    items: languagesList.toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        language = newValue!;
                      });
                    },
                    hintText: 'Prompt Language',
                    selectedItem: language!
                ),
                PromptDropdownButton(
                    items: categoriesList.toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    },
                    hintText: 'Category',
                    selectedItem: category!
                ),
                const Text('Placeholder',
                    style: TextStyle(fontSize: 3, color: Colors.transparent)
                ),
              ],
            ),
            const Text('Name',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
            ),
            PromptTextFormField(
              hintText: 'Name of the prompt',
              hintMaxLines: 1,
              onChanged: (value) {
                name = value;
              },
            ),
            const Text('Description (Optional)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
            ),
            PromptTextFormField(
              hintText:
                  'Describe your prompt so others can have a better understanding',
              hintMaxLines: 2,
              onChanged: (value) {
                description = value;
              },
            ),
            const Text(
              'Prompt',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const PromptHelperCard(),
            PromptTextFormField(
              hintText:
                  'e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]',
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
