import 'package:flutter/material.dart';

class PublishBotPage extends StatefulWidget {
  const PublishBotPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PublishBotPageState createState() => _PublishBotPageState();
}

class _PublishBotPageState extends State<PublishBotPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Changelog",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 5,
              maxLength: 2000,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter changelog here...',
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' Publish to',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "By publishing your bot on the following platforms, you fully understand and agree to abide by Terms of service for each publishing channel (including, but not limited to, any privacy policy, community guidelines, data processing agreement, etc.).",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              "Publishing platform",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _buildPlatformRow(),
                  _buildPlatformRow(),
                  _buildPlatformRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (bool? value) {}),
          const Icon(Icons.home),
          const SizedBox(width: 8),
          const Text("Name"),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text("Not Configured"),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Configure",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
