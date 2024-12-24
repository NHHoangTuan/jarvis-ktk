import 'package:flutter/material.dart';
import 'package:jarvis_ktk/data/models/knowledge.dart';
import 'package:jarvis_ktk/data/models/mock_data.dart';

import 'connect_dialog_base.dart';

DataSource selectedDataSource = dataSourceOptions[0];

class AddUnitContent extends StatelessWidget {
  final GlobalKey<ConnectDialogBaseState> connectDialogKey;

  const AddUnitContent({super.key, required this.connectDialogKey});

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> dialogMap = {
      'Local files': FileUploadDialog(connectDialogKey: connectDialogKey,),
      'Website': WebsiteConnectDialog(connectDialogKey: connectDialogKey,),
      'Google Drive': const GoogleDriveConnectDialog(),
      'Slack': SlackConnectDialog(connectDialogKey: connectDialogKey,),
      'Confluence': ConfluenceConnectDialog(connectDialogKey: connectDialogKey,),
    };

    return dialogMap[selectedDataSource.title] ?? const SizedBox();
  }
}

class FileUploadDialog extends StatelessWidget {
  final GlobalKey<ConnectDialogBaseState> connectDialogKey;

  const FileUploadDialog({super.key, required this.connectDialogKey});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      key: connectDialogKey,
      fields: [
        FilePickerField(key: 'selectedFile', title: 'Upload local file'),
      ],
    );
  }
}

class WebsiteConnectDialog extends StatelessWidget {
  final GlobalKey<ConnectDialogBaseState> connectDialogKey;

  const WebsiteConnectDialog({super.key, required this.connectDialogKey});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      key: connectDialogKey,
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
  final GlobalKey<ConnectDialogBaseState> connectDialogKey;

  const SlackConnectDialog({super.key, required this.connectDialogKey});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      key: connectDialogKey,
      fields: [
        ConnectDialogField(key: 'unitName', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'slackWorkspace', title: 'Slack Workspace URL', hintText: 'slack workspace URL'),
        ConnectDialogField(key: 'slackBotToken', title: 'Slack Bot Token', hintText: 'slack bot token'),
      ],
    );
  }
}

class ConfluenceConnectDialog extends StatelessWidget {
  final GlobalKey<ConnectDialogBaseState> connectDialogKey;

  const ConfluenceConnectDialog({super.key, required this.connectDialogKey});

  @override
  Widget build(BuildContext context) {
    return ConnectDialogBase(
      key: connectDialogKey,
      fields: [
        ConnectDialogField(key: 'unitName', title: 'Name', hintText: 'name'),
        ConnectDialogField(key: 'wikiPageUrl', title: 'Wiki Page URL', hintText: 'wiki page URL'),
        ConnectDialogField(key: 'confluenceUsername', title: 'Confluence Username', hintText: 'confluence username'),
        ConnectDialogField(key: 'confluenceAccessToken', title: 'Confluence Access Token', hintText: 'confluence access token'),
      ],
    );
  }
}