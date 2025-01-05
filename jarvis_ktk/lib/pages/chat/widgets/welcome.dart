import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';
import 'package:jarvis_ktk/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart'; // Import thư viện này
import 'command_card.dart'; // Import CommandCard nếu cần

class WelcomeMessage extends StatelessWidget {
  final void Function(String message) sendMessage;
  const WelcomeMessage({Key? key, required this.sendMessage}) : super(key: key);

  void _openUpgradeLink() async {
    final Uri url = Uri.parse('https://admin.dev.jarvis.cx/pricing/overview');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.waving_hand,
                    size: 30,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hi, have a good day',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'I’m Jarvis, your personal assistant. \nHere are some of my amazing powers',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Mục Nâng cấp tài khoản
              Card(
                color: Colors.amber[100],
                child: InkWell(
                  onTap: _openUpgradeLink,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ResizedImage(
                            imagePath: 'assets/upgrade.png',
                            width: 50,
                            height: 50),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Upgrade Your Account\nUnlock more features',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Card(
                      color: Colors.blue[100],
                      child: InkWell(
                        onTap: () {
                          // Add action for upload image
                          ToastUtils.showToast("Coming soon");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(Icons.image, size: 48),
                              SizedBox(height: 8),
                              Text('Upload', style: TextStyle(fontSize: 16)),
                              Text('Upload Your Image'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'You can ask me like this',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CommandCard(
                    command: 'Write an email',
                    description: 'to submission project',
                    onTap: () =>
                        sendMessage('Write an email to submission project'),
                  ),
                  CommandCard(
                    command: 'Suggest events',
                    description: 'for this summer',
                    onTap: () => sendMessage('Suggest events for this summer'),
                  ),
                  CommandCard(
                    command: 'List some books',
                    description: 'related to adventure',
                    onTap: () =>
                        sendMessage('List some books related to adventure'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
