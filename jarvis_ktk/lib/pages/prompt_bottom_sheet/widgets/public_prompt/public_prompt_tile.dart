import 'package:flutter/material.dart';

import '../../models/prompt.dart';

class PublicPromptTile extends StatelessWidget {
  final PublicPrompt prompt;

  const PublicPromptTile({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(prompt.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold)),
      subtitle: prompt.description != null ? Text(prompt.description!) : null,
      subtitleTextStyle: TextStyle(
        color: Colors.grey[500],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(0.0),
                width: 30.0,
                height: 30.0,
                child: IconButton(
                  alignment: Alignment.center,
                  icon: Icon(
                    prompt.isFavorite ? Icons.star : Icons.star_border,
                    color: prompt.isFavorite ? Colors.black : null,
                    size: 15,
                  ),
                  onPressed: () {
                    // Handle favorite button press
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(0.0),
                width: 30.0,
                height: 30.0,
                child: IconButton(
                  icon: const Icon(Icons.info_outline, size: 15),
                  onPressed: () {
                    // Handle info button press
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
