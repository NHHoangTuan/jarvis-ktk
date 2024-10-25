import 'package:flutter/material.dart';
import '../prompt_list.dart';
import '../public_prompt/data/prompt_mock_data.dart';

class MyPromptContent extends StatelessWidget {
  const MyPromptContent({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body:CombinedPromptList(combinedPrompts: [...myPrompts, ...publicPrompts])
    );
  }
}
