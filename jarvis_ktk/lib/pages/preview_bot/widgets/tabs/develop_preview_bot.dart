import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/providers/bot_provider.dart';
import 'package:provider/provider.dart';

class DevelopPreviewBotPage extends StatefulWidget {
  const DevelopPreviewBotPage({super.key});

  @override
  _DevelopPreviewBotPageState createState() => _DevelopPreviewBotPageState();
}

class _DevelopPreviewBotPageState extends State<DevelopPreviewBotPage> {
  final _editPromptController = TextEditingController();
  String? _initialInstructions;
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Lấy giá trị bot từ Provider
    final bot = Provider.of<BotProvider>(context, listen: false).selectedBot;

    // Khởi tạo controller với giá trị bot.instructions hoặc '' nếu null
    _editPromptController.text = bot?.instructions ?? '';
    _initialInstructions = bot?.instructions; // Lưu giá trị ban đầu

    _editPromptController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _editPromptController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      // Cập nhật giá trị bot.instructions trong provider
      final bot = Provider.of<BotProvider>(context, listen: false).selectedBot;
      if (bot != null && _editPromptController.text != _initialInstructions) {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<BotProvider>(context, listen: false).updatePromptBot(
            bot.id, bot.assistantName, _editPromptController.text);

        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Persona & Prompt'),
            const SizedBox(
                width: 8.0), // Add some space between the text and the icon
            _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.check_circle),
          ],
        ),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _editPromptController, // Sử dụng controller
              maxLines: null, // Allow unlimited lines
              decoration: const InputDecoration(
                hintText:
                    'Design the bot\'s persona, features and workflows using natural language',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: InputBorder.none, // Remove the underline
              ),
            ),
          ),
        ],
      ),
    );
  }
}
