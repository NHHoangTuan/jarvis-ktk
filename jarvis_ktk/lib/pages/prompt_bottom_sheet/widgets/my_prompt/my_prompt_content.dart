import 'package:flutter/material.dart';
import '../../models/prompt.dart';
import '../prompt_list.dart';

class MyPromptContent extends StatelessWidget {
  const MyPromptContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> combinedPrompts = [
      MyPrompt(name: 'Brainstorm', prompt: 'Generate new ideas.'),
      MyPrompt(name: 'Translate to Japanese', prompt: 'Translate text to Japanese.'),
      PublicPrompt(
        category: 'Category 1',
        description: 'Improve your spelling and grammar by correcting errors in your writing.',
        language: 'English',
        name: 'Grammar corrector',
        prompt: '',
      ),
    ];

    return Scaffold(
        backgroundColor: Colors.white,
        body:CombinedPromptList(combinedPrompts: combinedPrompts)
    );
  }
}
