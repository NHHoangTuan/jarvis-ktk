import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/email_reply.dart';
import 'package:jarvis_ktk/utils/colors.dart';

class ReplyDraftScreen extends StatefulWidget {
  final void Function(EmailReply emailReply) onSendMessage;

  const ReplyDraftScreen({super.key, required this.onSendMessage});

  @override
  _ReplyDraftScreenState createState() => _ReplyDraftScreenState();
}

class _ReplyDraftScreenState extends State<ReplyDraftScreen> {
  String? selectedFormat = 'Email';
  String? selectedTone = 'Professional';
  String? selectedLength = 'Medium';
  String? selectedLanguage = 'English';

  final originalTextController = TextEditingController();
  final replyTextController = TextEditingController();

  final formats = ['Comment', 'Email', 'Message', 'Twitter'];
  final tones = [
    'Formal',
    'Casual',
    'Professional',
    'Enthusiastic',
    'Informational',
    'Funny'
  ];
  final lengths = ['Short', 'Medium', 'Long'];
  final languages = ['English', 'Tiếng Việt'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmailTextInput(
                controller: originalTextController,
                hintText: 'The original text you want to reply to',
              ),
              EmailTextInput(
                controller: replyTextController,
                hintText: 'The general content of your reply to the above text',
              ),
              EmailStyleTitle(
                title: 'Format',
                styles: formats,
                selectedLanguage: selectedFormat!,
                onSelected: (format) {
                  setState(() {
                    selectedFormat = format;
                  });
                },
                icon: Icons.article_outlined,
              ),
              EmailStyleTitle(
                title: 'Tone',
                styles: tones,
                selectedLanguage: selectedTone!,
                onSelected: (tone) {
                  setState(() {
                    selectedTone = tone;
                  });
                },
                icon: Icons.sentiment_satisfied_outlined,
              ),
              EmailStyleTitle(
                title: 'Length',
                styles: lengths,
                selectedLanguage: selectedLength!,
                onSelected: (length) {
                  setState(() {
                    selectedLength = length;
                  });
                },
                icon: Icons.format_size_outlined,
              ),
              EmailStyleTitle(
                title: 'Language',
                styles: languages,
                selectedLanguage: selectedLanguage!,
                onSelected: (language) {
                  setState(() {
                    selectedLanguage = language;
                  });
                },
                icon: Icons.translate_rounded,
              ),
              ElevatedButton(
                onPressed: () {
                  _generateDraft();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SimpleColors.lightBlue,
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text('Generate draft'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateDraft() {
    final emailReply = EmailReply(
        mainIdea: replyTextController.text,
        action: 'Reply to this email',
        email: originalTextController.text,
        metadata: EmailMetadata(
          style: EmailStyle(
            length: selectedLength,
            formality: selectedTone,
            tone: selectedTone,
          ),
          language: selectedLanguage,
        ));
    widget.onSendMessage(emailReply);
  }
}

class EmailTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const EmailTextInput({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        autofocus: false,
        maxLines: 4,
        minLines: 3,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 14),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class EmailStyleTitle extends StatelessWidget {
  final String title;
  final List<String> styles;
  final String selectedLanguage;
  final ValueChanged<String> onSelected;
  final IconData icon;

  const EmailStyleTitle({
    super.key,
    required this.title,
    required this.styles,
    required this.selectedLanguage,
    required this.onSelected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Wrap(
            spacing: 8.0,
            children: styles.map((style) {
              return ChoiceChip(
                label: Text(style, style: const TextStyle(fontSize: 10)),
                selected: selectedLanguage == style,
                onSelected: (selected) {
                  if (selected) {
                    onSelected(style);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
