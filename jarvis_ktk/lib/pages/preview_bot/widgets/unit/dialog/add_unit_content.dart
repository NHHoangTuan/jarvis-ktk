import 'package:flutter/material.dart';
import '../../../../prompt_bottom_sheet/widgets/common_widgets.dart';
import '../../../../../utils/colors.dart';

import '../../../models/knowledge.dart';
import '../../../models/mock_data.dart';
import '../../common_widgets.dart';
import 'connect_dialog_base.dart';

DataSource selectedDataSource = dataSourceOptions[0];

class AddUnitContent extends StatelessWidget {
  const AddUnitContent({super.key});

  static final Map<String, Widget> dialogMap = {
    'Local files': const FileUploadDialog(),
    'Website': const WebsiteConnectDialog(),
    'Github repositories': const GithubConnectDialog(),
    'Gitlab repositories': const GitlabConnectDialog(),
    'Google Drive': const GoogleDriveConnectDialog(),
    'Slack': const SlackConnectDialog(),
    'Confluence': const ConfluenceConnectDialog(),
    'Jira': const JiraConnectDialog(),
    'Hubspot': const HubspotConnectDialog(),
    'Linear': const LinearConnectDialog(),
    'Notion': const NotionConnectDialog(),
  };

  @override
  Widget build(BuildContext context) {
    return dialogMap[selectedDataSource.title] ?? const SizedBox();
  }
}

class FileUploadDialog extends StatelessWidget {
  const FileUploadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        FilePickerField(key: 'selectedFile', title: 'Upload local file'),
      ],
    );
  }
}

class WebsiteConnectDialog extends StatelessWidget {
  const WebsiteConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        ConnectDialogField(key: 'name', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'websiteUrl', title: 'Website URL', hintText: 'website URL'),
      ],
    );
  }
}

class GitlabConnectDialog extends StatefulWidget {
  const GitlabConnectDialog({super.key});

  @override
  State<GitlabConnectDialog> createState() => _GitlabConnectDialog();
}

class GoogleDriveConnectDialog extends StatelessWidget {
  const GoogleDriveConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        ConnectDialogField(key: 'name', title: 'Name', hintText: 'name'),
        FilePickerField(key: 'googleDriveCredential', title: 'Google Drive Credential'),
      ],
    );
  }
}

class SlackConnectDialog extends StatelessWidget {
  const SlackConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        ConnectDialogField(key: 'name', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'slackWorkspaceUrl', title: 'Slack Workspace URL', hintText: 'slack workspace URL'),
        ConnectDialogField(key: 'slackBotToken', title: 'Slack Bot Token', hintText: 'slack bot token'),
      ],
    );
  }
}

class ConfluenceConnectDialog extends StatelessWidget {
  const ConfluenceConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        ConnectDialogField(key: 'name', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'wikiPageUrl', title: 'Wiki Page URL', hintText: 'wiki page URL'),
        ConnectDialogField(key: 'confluenceUsername', title: 'Confluence Username', hintText: 'confluence username'),
        ConnectDialogField(key: 'confluenceAccessToken', title: 'Confluence Access Token', hintText: 'confluence access token'),
      ],
    );
  }
}

class JiraConnectDialog extends StatelessWidget {
  const JiraConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        ConnectDialogField(key: 'name', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'jiraUrl', title: 'Jira URL', hintText: 'jira URL'),
        ConnectDialogField(key: 'jiraUsername', title: 'Jira Username', hintText: 'jira username'),
        ConnectDialogField(key: 'jiraApiToken', title: 'Jira API Token', hintText: 'jira api token'),
      ],
    );
  }
}

class HubspotConnectDialog extends StatelessWidget {
  const HubspotConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        ConnectDialogField(key: 'name', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'hubspotAccessToken', title: 'Hubspot Access Token', hintText: 'hubspot access token'),
      ],
    );
  }
}

class LinearConnectDialog extends StatelessWidget {
  const LinearConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        ConnectDialogField(key: 'name', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'linearApiKey', title: 'Linear API Key', hintText: 'linear api key'),
      ],
    );
  }
}

class NotionConnectDialog extends StatelessWidget {
  const NotionConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      fields: [
        ConnectDialogField(key: 'name', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'rootPageId', title: 'Root Page ID', hintText: 'root page ID'),
        ConnectDialogField(key: 'notionIntegrationToken', title: 'Notion Integration Token', hintText: 'token'),
      ],
    );
  }
}

class GithubConnectDialog extends StatelessWidget {
  const GithubConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
        color: SimpleColors.babyBlue.withOpacity(0.1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GitHub icon
            CircleAvatar(
              backgroundImage: Image.asset(selectedDataSource.imagePath).image,
              radius: 40,
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 20),
            // "GitHub is not authorized" text
            const Text(
              'Github is not authorized',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // "Click button to authorize" text
            const Text(
              'Click button to authorize',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // Authorize button
            ElevatedButton(
              onPressed: () {
                // Add authorization logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Authorize',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GitlabConnectDialog extends State<GitlabConnectDialog> {
  String? name;
  String? gitlabUrl;
  String? gitlabProjectName;
  String? gitlabProjectOwner;
  String? gitlabAccessToken;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
        color: SimpleColors.babyBlue.withOpacity(0.1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HeaderText(),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextFormTitle(title: '* Name:'),
                    PromptTextFormField(
                      hintText: 'Enter name',
                      onChanged: (value) {
                        name = value;
                      },
                      hintMaxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextFormTitle(title: '* Gitlab Project Owner:'),
                    PromptTextFormField(
                      hintText: 'Enter project owner',
                      onChanged: (value) {
                        name = value;
                      },
                      hintMaxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const TextFormTitle(title: "* Gitlab URL:"),
          PromptTextFormField(
            hintText: 'Enter project url',
            onChanged: (value) {
              name = value;
            },
            hintMaxLines: 1,
          ),
          const TextFormTitle(title: '* Gitlab Project Name:'),
          PromptTextFormField(
            hintText: 'Enter project name',
            onChanged: (value) {
              name = value;
            },
            hintMaxLines: 1,
          ),
          const TextFormTitle(title: '* Gitlab Access Token:'),
          PromptTextFormField(
            hintText: 'Enter access token',
            onChanged: (value) {
              name = value;
            },
            hintMaxLines: 1,
          ),
        ],
      ),
    );
  }
}
