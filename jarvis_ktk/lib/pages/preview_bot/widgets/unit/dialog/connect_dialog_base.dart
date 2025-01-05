import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/colors.dart';
import '../../../../prompt_bottom_sheet/widgets/common_widgets.dart';
import '../../common_widgets.dart';

class ConnectDialogBase extends StatefulWidget {
  final List<ConnectDialogField> fields;

  const ConnectDialogBase({super.key, required this.fields});

  @override
  State<ConnectDialogBase> createState() => ConnectDialogBaseState();
}

class ConnectDialogBaseState extends State<ConnectDialogBase> {
  final Map<String, String?> fieldValues = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
        color: SimpleColors.babyBlue.withOpacity(0.1),
      ),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HeaderText(),
                const Divider(),
                ...widget.fields.map((field) {
                  if (field is FilePickerField) {
                    return Column(
                      children: [
                        TextFormTitle(title: '* ${field.title}:'),

                        FilePickerWidget(
                          selectedFile: fieldValues[field.key],
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: [
                                'c', 'cpp', 'docx', 'html', 'java', 'json', 'md', 'pdf', 'php', 'pptx', 'py', 'rb', 'tex', 'txt'
                              ],
                            );
                            if (result != null) {
                              setState(() {
                                fieldValues[field.key] = result.files.single.path;
                              });
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        TextFormTitle(title: '* ${field.title}:'),
                        PromptTextFormField(
                          hintText: 'Enter ${field.hintText}',
                          onChanged: (value) {
                            fieldValues[field.key] = value;
                          },
                          hintMaxLines: 1,
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectDialogField {
  final String key;
  final String title;
  final String hintText;

  ConnectDialogField(
      {required this.key, required this.title, required this.hintText});
}

class FilePickerField extends ConnectDialogField {
  FilePickerField({required super.key, required super.title})
      : super(hintText: '');
}

class FilePickerWidget extends StatelessWidget {
  final String? selectedFile;
  final VoidCallback onTap;

  const FilePickerWidget({
    super.key,
    required this.selectedFile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: SimpleColors.babyBlue.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
          color: SimpleColors.babyBlue.withOpacity(0.1),
        ),
        child: Center(
          child: selectedFile == null
              ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload, size: 40, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                'Click this area to upload',
                style:
                TextStyle(fontSize: 16, color: SimpleColors.darkBlue),
              ),
            ],
          )
              : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    // only show the file name
                    selectedFile!.split('/').last,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Click to upload another file',
                    style:
                    TextStyle(fontSize: 16, color: SimpleColors.darkBlue),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}