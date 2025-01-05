import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

import '../../../utils/colors.dart';
import 'unit/dialog/add_unit_content.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: ResizedImage(
            imagePath: selectedDataSource.imagePath, width: 18, height: 18),
        title: Text(
          selectedDataSource.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline,
              size: 20, color: SimpleColors.blue),
          onPressed: () {
            if (selectedDataSource.type == DataSourceType.web) {
              showWebsiteGuide(context);
            } else if (selectedDataSource.type == DataSourceType.slack) {
              showSlackSetupGuide(context);
            } else if (selectedDataSource.type == DataSourceType.local_file) {
              showLocalFilePicker(context);
            } else if (selectedDataSource.type == DataSourceType.confluence) {
              showConfluenceSetupGuide(context);
            }
          },
        ));
  }
}

void showLocalFilePicker(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Allowed File Types'),
        content: RichText(
          text: const TextSpan(
            text: 'The following file types are allowed:\n',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text:
                    '.c, .cpp, .docx, .html, .java, .json, .md, .pdf, .php, .pptx, .py, .rb, .tex, .txt',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showWebsiteGuide(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Website Guide'),
        content: RichText(
          text: const TextSpan(
            text:
                'Paste the URL of the website you want to scrape.\nFor example:\n',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'https://www.example.com/',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showConfluenceSetupGuide(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confluence Guide', style: TextStyle(fontWeight: FontWeight.bold),),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How it works',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'The Confluence connector pulls in all pages and comments from the specified spaces with a limit of 128 pages.\n',
              ),
              Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Authorization',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Log into Confluence and click your profile image and select Manage Account from the menu.\n'
                    '2. Navigate to Security and click Create and manage API tokens.\n'
                    '3. Click Create API token.\n'
                    '4. Enter a Label and click Create.\n'
                    '5. You can copy the token to clipboard.\n'
                    '6. Username is the user\'s email address.\n',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showSlackSetupGuide(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Slack Guide', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  text: '',
                  style: TextStyle(color: Colors.black,),
                  children: [
                    TextSpan(
                      text: 'Note: You must be an admin of the Slack workspace to set up the connector\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. Navigate and sign in to Slack apps\n\n'
                          '2. Create a new Slack app:\n'
                          '   - Click the ',
                    ),
                    TextSpan(
                      text: 'Create New App',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' button in the top right.\n'
                          '   - Select ',
                    ),
                    TextSpan(
                      text: 'From an app manifest',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' option.\n'
                          '   - Select the relevant workspace from the dropdown and click ',
                    ),
                    TextSpan(
                      text: 'Next',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '.\n\n'
                          '3. Copy the following manifest into the text box:\n\n',
                    ),
                  ],
                ),
              ),
              const CopyableTextField(
                text: '''
display_information:
  name: DanswerConnector
  description: ReadOnly Connector for indexing Danswer
features:
  bot_user:
    display_name: DanswerConnector
    always_online: false
oauth_config:
  scopes:
    bot:
      - channels:history
      - channels:read
      - groups:history
      - groups:read
      - channels:join
      - im:history
      - users:read
settings:
  org_deploy_enabled: false
  socket_mode_enabled: false
  token_rotation_enabled: false
                ''',
              ),
              RichText(
                text: const TextSpan(
                  text: '\n4. Click the ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Create',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' button.\n\n'
                          '5. In the app page, navigate to the ',
                    ),
                    TextSpan(
                      text: 'OAuth & Permissions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' tab under the ',
                    ),
                    TextSpan(
                      text: 'Features',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' header.\n\n'
                          '6. Copy the ',
                    ),
                    TextSpan(
                      text: 'Bot User OAuth Token',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ', this will be used to access Slack.\n',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
class CopyableTextField extends StatelessWidget {
  final String text;

  const CopyableTextField({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: text),
            readOnly: true,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 8),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: text));
          },
        ),
      ],
    );
  }
}

class TextFormTitle extends StatelessWidget {
  final String title;

  const TextFormTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final String title;
  final String content;

  const DeleteDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        SizedBox(
          width: 80,
          height: 35,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.transparent,
            ),
            onPressed: () => Navigator.of(context).pop(false), // Confirm delete
            child: const Text('Cancel',
                style: TextStyle(color: SimpleColors.blue)),
          ),
        ),
        SizedBox(
          width: 80,
          height: 35,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true), // Confirm delete
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  static Future<bool?> show(
      {required BuildContext context,
      required String title,
      required String content}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(
          title: title,
          content: content,
        );
      },
    );
  }
}
