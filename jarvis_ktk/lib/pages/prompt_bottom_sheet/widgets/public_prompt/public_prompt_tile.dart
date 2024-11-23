import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_ktk/data/models/user.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/delete_prompt_dialog.dart';
import 'package:jarvis_ktk/pages/prompt_bottom_sheet/widgets/public_prompt/edit_prompt/edit_public_prompt_dialog.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import '../../../../data/models/prompt.dart';
import 'info_dialog/info_dialog.dart';

class PublicPromptTile extends StatefulWidget {
  final PublicPrompt prompt;
  final VoidCallback onDelete;
  final void Function(PublicPrompt) onClick;

  const PublicPromptTile(
      {super.key,
      required this.prompt,
      required this.onDelete,
      required this.onClick});

  @override
  State<PublicPromptTile> createState() => _PublicPromptTileState();
}

class _PublicPromptTileState extends State<PublicPromptTile> {
  late bool isFavorite;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    isFavorite = widget.prompt.isFavorite;
  }

  Future<void> _initializeUser() async {
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        _user = User.fromJson(userMap);
      });
    }
  }

  void onUpdate(PublicPrompt prompt) {
    setState(() {
      widget.prompt.title = prompt.title;
      widget.prompt.description = prompt.description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  if (_user?.id == widget.prompt.userId)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0.0),
                          width: 32.0,
                          height: 32.0,
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 16),
                            onPressed: () {
                              showEditPublicPromptDialog(
                                  context, widget.prompt, onUpdate);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0.0),
                          width: 32.0,
                          height: 32.0,
                          child: IconButton(
                            icon: const Icon(Icons.delete, size: 16),
                            onPressed: () {
                              showConfirmDeletePromptDialog(
                                  context, widget.prompt, widget.onDelete);
                            },
                          ),
                        ),
                      ],
                    )
                  else
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
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                if (isFavorite) {
                                  await getIt<PromptApi>()
                                      .removePromptFromFavorite(
                                          widget.prompt.id);
                                } else {
                                  await getIt<PromptApi>()
                                      .addPromptToFavorite(widget.prompt.id);
                                }
                                setState(() {
                                  isFavorite = !isFavorite;
                                  widget.prompt.isFavorite = isFavorite;
                                });
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to update favorite status: $e'),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
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
                              showInfoDialog(context, widget.prompt, widget.onClick);
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
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
