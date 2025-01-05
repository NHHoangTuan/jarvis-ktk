import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/email_reply.dart';
import 'package:jarvis_ktk/data/network/email_api.dart';
import 'package:jarvis_ktk/pages/email_reply/widgets/email_tab_bar.dart';
import 'package:jarvis_ktk/services/service_locator.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReplyDraftScreen extends StatefulWidget {
  final void Function(EmailReply emailReply) onSendMessage;

  const ReplyDraftScreen({super.key, required this.onSendMessage});

  @override
  _ReplyDraftScreenState createState() => _ReplyDraftScreenState();
}

class _ReplyDraftScreenState extends State<ReplyDraftScreen>
    with SingleTickerProviderStateMixin {
  String? selectedFormat = 'Email';
  String? selectedTone = 'Professional';
  String? selectedLength = 'Medium';
  String? selectedLanguage = 'English';
  late TabController _tabController;

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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmailTabBar(
              tabController: _tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEmailResponse(),
                  const SuggestReplyIdeas(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailResponse() {
    return SingleChildScrollView(
        child: Column(
      children: [
        EmailTextInput(
          controller: originalTextController,
          hintText: 'The email content you want to reply to',
        ),
        EmailTextInput(
          controller: replyTextController,
          hintText: 'The main idea of your reply',
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
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedButton(
            onPressed: () {
              _responseEmail();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: SimpleColors.lightBlue,
                minimumSize: const Size(200, 50)),
            child: const Text('Response Email',
                style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    ));
  }

  void _responseEmail() {
    if (originalTextController.text.isEmpty ||
        replyTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both fields must be filled out')),
      );
      return;
    }
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

class SuggestReplyIdeas extends StatefulWidget {
  const SuggestReplyIdeas({super.key});

  @override
  _SuggestReplyIdeasState createState() => _SuggestReplyIdeasState();
}

class _SuggestReplyIdeasState extends State<SuggestReplyIdeas> {
  String? selectedLanguage = 'English';
  final originalTextController = TextEditingController();
  List<String> suggestedIdeas = [];
  final languages = ['English', 'Tiếng Việt'];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                EmailTextInput(
                  controller: originalTextController,
                  hintText: 'The email content you want to reply to',
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
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LoadingAnimationWidget.inkDrop(
                      color: Colors.blueGrey,
                      size: 40,
                    ),
                  ),
                if (suggestedIdeas.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Suggested Reply Ideas:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  for (var idea in suggestedIdeas)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: ListTile(
                          leading: Icon(Icons.lightbulb_outline,
                              color: Colors.blueGrey),
                          title:
                              Text(idea, style: const TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedButton(
            onPressed: _suggestReply,
            style: ElevatedButton.styleFrom(
              backgroundColor: SimpleColors.lightBlue,
              minimumSize: const Size(200, 50),
            ),
            child: const Text(
              'Suggest Ideas',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _suggestReply() async {
    if (originalTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The email content must be filled out')),
      );
      return;
    }

    setState(() {
      isLoading = true;
      suggestedIdeas.clear();
    });

    try {
      final emailReply = EmailReply(
        mainIdea: originalTextController.text,
        action: 'Reply to this email',
        email: originalTextController.text,
        metadata: EmailMetadata(
          subject: "",
          receiver: "",
          sender: "",
          language: selectedLanguage,
        ),
      );
      final response = await getIt<EmailApi>().suggestReplyIdeas(emailReply);
      setState(() {
        suggestedIdeas = response.ideas;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                showCheckmark: false,
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
