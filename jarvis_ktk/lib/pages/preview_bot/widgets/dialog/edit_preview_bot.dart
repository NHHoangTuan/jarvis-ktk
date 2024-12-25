import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/bot.dart';
import '../../../../data/providers/bot_provider.dart';

class EditPreviewBotPage extends StatefulWidget {
  final Bot bot;
  const EditPreviewBotPage({super.key, required this.bot});

  @override
  // ignore: library_private_types_in_public_api
  _EditPreviewBotPageState createState() => _EditPreviewBotPageState();
}

class _EditPreviewBotPageState extends State<EditPreviewBotPage> {
  final _botNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _botNameCharCount = 0;
  int _descriptionCharCount = 0;
  bool _isLoading = false;

  final ScrollController _descriptionScrollController = ScrollController();
  final ValueNotifier<bool> _isTitleNotEmpty = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _botNameController.addListener(() {
      _isTitleNotEmpty.value = _botNameController.text.isNotEmpty;
    });
    _botNameController.addListener(_updateBotNameCharCount);
    _descriptionController.addListener(_updateDescriptionCharCount);

    _botNameController.text = widget.bot.assistantName;
    _descriptionController.text = widget.bot.description;
  }

  void _updateBotNameCharCount() {
    setState(() {
      _botNameCharCount = _botNameController.text.length;
    });
  }

  void _updateDescriptionCharCount() {
    setState(() {
      _descriptionCharCount = _descriptionController.text.length;
    });
  }

  void _submitData() async {
    if (_botNameController.text.isEmpty) {
      return;
    }

    String botName = _botNameController.text;
    String botDescription = _descriptionController.text;

    if (botDescription.isEmpty) {
      botDescription = '';
    }

    // Thêm loading cho nút apply
    // Chuyển sang trạng thái loading
    setState(() {
      _isLoading = true;
    });

    await Provider.of<BotProvider>(context, listen: false)
        .updateBot(widget.bot.id, botName, botDescription);

    // Chuyển sang trạng thái không loading
    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();

    showToast("Bot updated successfully");
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void dispose() {
    _botNameController.removeListener(_updateBotNameCharCount);
    _descriptionController.removeListener(_updateDescriptionCharCount);
    _botNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Bot',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _botNameController,
                  decoration: InputDecoration(
                    labelText: 'Bot Name',
                    counterText: '$_botNameCharCount/50',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter bot name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Scrollbar(
                  controller: _descriptionScrollController,
                  child: SingleChildScrollView(
                    controller: _descriptionScrollController,
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        counterText: '$_descriptionCharCount/2000',
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3, // Allow multiple lines
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    // Handle image upload
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(Icons.add_a_photo),
                  ),
                ),
                const SizedBox(height: 32.0),
                ValueListenableBuilder<bool>(
                  valueListenable: _isTitleNotEmpty,
                  builder: (context, isTitleNotEmpty, child) {
                    return Ink(
                      decoration: ShapeDecoration(
                        color: isTitleNotEmpty
                            ? Colors.blue[100]
                            : Colors.grey[350],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: TextButton(
                        onPressed: _isLoading ? null : _submitData,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Apply',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
