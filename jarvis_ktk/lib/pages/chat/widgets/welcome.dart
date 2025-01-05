import 'package:flutter/material.dart';
import 'command_card.dart'; // Import CommandCard nếu cần

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
        child: SingleChildScrollView(
          child: Column(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Card(
                      color: Colors.blue[100],
                      child: InkWell(
                        onTap: () {
                          // Add action for upload image
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
                    onTap: () {},
                  ),
                  CommandCard(
                    command: 'Suggest events',
                    description: 'for this summer',
                    onTap: () {},
                  ),
                  CommandCard(
                    command: 'List some books',
                    description: 'related to adventure',
                    onTap: () {},
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
