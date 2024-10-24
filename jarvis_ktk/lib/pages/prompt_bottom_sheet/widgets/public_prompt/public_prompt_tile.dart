import 'package:flutter/material.dart';

import '../../models/prompt.dart';
import 'info_dialog/info_dialog.dart';

class PublicPromptTile extends StatelessWidget {
  final PublicPrompt prompt;

  const PublicPromptTile({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ListTile title
              Text(
                prompt.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 32.0,
                    height: 32.0,
                    child: IconButton(
                      alignment: Alignment.center,
                      icon: Icon(
                        prompt.isFavorite ? Icons.star : Icons.star_border,
                        color: prompt.isFavorite ? Colors.black : null,
                        size: 16,
                      ),
                      onPressed: () {
                        // Handle favorite button press
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 32.0,
                    height: 32.0,
                    child: IconButton(
                      icon: const Icon(Icons.info_outline, size: 16),
                      onPressed: () {
                        // Handle info button press
                        showInfoDialog(context, prompt);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            prompt.description!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          )
        ],
      ),
    );
  }
}
