import 'knowledge.dart';

final List<DataSource> dataSourceOptions = [
  DataSource(
    title: 'Local files',
    subtitle: 'Upload pdf, docx, ...',
    imagePath: 'assets/unit/file.png',
    type: DataSourceType.local_file,

  ),
  DataSource(
    title: 'Website',
    subtitle: 'Connect Website to get data',
    imagePath: 'assets/unit/web.png',
    type: DataSourceType.web,
  ),
  DataSource(
    title: 'Slack',
    subtitle: 'Connect Slack to get data',
    imagePath: 'assets/unit/slack.png',
    type: DataSourceType.slack,
  ),
  DataSource(
    title: 'Confluence',
    subtitle: 'Connect Confluence to get data',
    imagePath: 'assets/unit/confluence.png',
    type: DataSourceType.confluence,
  ),
];
