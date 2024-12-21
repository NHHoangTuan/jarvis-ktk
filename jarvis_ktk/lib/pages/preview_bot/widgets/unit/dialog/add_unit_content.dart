import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/models/mock_data.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/services/service_locator.dart';

import 'connect_dialog_base.dart';

DataSource selectedDataSource = dataSourceOptions[0];

class AddUnitContent extends StatelessWidget {
  final String knowledgeId;
  final void Function() onConnect;

  const AddUnitContent({super.key, required this.knowledgeId, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> dialogMap = {
      'Local files': FileUploadDialog(knowledgeId: knowledgeId, onConnect: onConnect,),
      'Website': const WebsiteConnectDialog(),
      'Google Drive': const GoogleDriveConnectDialog(),
      'Slack': const SlackConnectDialog(),
      'Confluence': const ConfluenceConnectDialog(),
    };

    return dialogMap[selectedDataSource.title] ?? const SizedBox();
  }
}

class FileUploadDialog extends StatelessWidget {
  final String knowledgeId;
  final void Function() onConnect;

  const FileUploadDialog({super.key, required this.knowledgeId, required this.onConnect});

  Future<void> _onConnect(Map<String, dynamic> fields) async {
    await getIt<KnowledgeApi>().uploadLocalFile(knowledgeId, fields['selectedFile']);
    onConnect();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      onConnect: _onConnect,
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
        ConnectDialogField(key: 'unitName', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'webUrl', title: 'Website URL', hintText: 'website URL'),
      ],
    );
  }
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
        ConnectDialogField(key: 'unitName', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'slackWorkspace', title: 'Slack Workspace URL', hintText: 'slack workspace URL'),
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
        ConnectDialogField(key: 'unitName', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'wikiPageUrl', title: 'Wiki Page URL', hintText: 'wiki page URL'),
        ConnectDialogField(key: 'confluenceUsername', title: 'Confluence Username', hintText: 'confluence username'),
        ConnectDialogField(key: 'confluenceAccessToken', title: 'Confluence Access Token', hintText: 'confluence access token'),
      ],
    );
  }
}