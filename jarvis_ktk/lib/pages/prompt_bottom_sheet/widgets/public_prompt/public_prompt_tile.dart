import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import '../../../../data/models/prompt.dart';
import 'info_dialog/info_dialog.dart';

class PublicPromptTile extends StatefulWidget {
  final PublicPrompt prompt;
  final VoidCallback onDelete;

  const PublicPromptTile(
      {super.key,
      required this.prompt,
      required this.onDelete});

  @override
  State<PublicPromptTile> createState() => _PublicPromptTileState();
}

class _PublicPromptTileState extends State<PublicPromptTile> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.prompt.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ListTile title
              Expanded(
                child: Text(
                  widget.prompt.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.black : null,
                        size: 16,
                      ),
                      onPressed: () async {
                        try {
                          await getIt<PromptApi>()
                              .addPromptToFavorite(widget.prompt.id!);
                          setState(() {
                            isFavorite = !isFavorite;
                            widget.prompt.isFavorite = isFavorite;
                          });
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to update favorite status: $e')),
                          );
                        }
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
                        showInfoDialog(context, widget.prompt);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (widget.prompt.description != null)
            Text(
              widget.prompt.description!,
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
