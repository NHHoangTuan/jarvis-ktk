import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/prompt.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/common_widgets.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/filter/filter_buttons.dart';

const Set<String> languagesList = <String>{'English', 'Spanish', 'French'};

class EditPublicPromptContent extends StatefulWidget {
  const EditPublicPromptContent({super.key, required this.prompt});

  final PublicPrompt prompt;

  @override
  State<EditPublicPromptContent> createState() => _EditPublicPromptContent();
}

class _EditPublicPromptContent extends State<EditPublicPromptContent>
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
        child: SingleChildScrollView(
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
                          widget.prompt.language = newValue!;
                        });
                      },
                      hintText: 'Prompt Language',
                      selectedItem:
                          widget.prompt.language ?? languagesList.first),
                  PromptDropdownButton(
                    items: FilterType.values
                        .map((e) => e.toString().split('.').last)
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.prompt.category = newValue!.toLowerCase();
                      });
                    },
                    hintText: 'Category',
                    selectedItem: widget.prompt.category.toTitleCase(),
                  ),
                  const Text('Placeholder',
                      style: TextStyle(fontSize: 1, color: Colors.transparent)),
                ],
              ),
              const Text('Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              PromptTextFormField(
                hintText: 'Name of the prompt',
                hintMaxLines: 1,
                initialValue: widget.prompt.title,
                onChanged: (value) {
                  widget.prompt.title = value;
                },
              ),
              const Text('Description (Optional)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              PromptTextFormField(
                hintText:
                    'Describe your prompt so others can have a better understanding',
                hintMaxLines: 2,
                initialValue: widget.prompt.description,
                onChanged: (value) {
                  widget.prompt.description = value;
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
                initialValue: widget.prompt.content,
                onChanged: (value) {
                  widget.prompt.content = value;
                },
              ),
            ],
          ),
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

class EditPublicPromptTitle extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String prompt;

  const EditPublicPromptTitle({super.key, required this.prompt})
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
