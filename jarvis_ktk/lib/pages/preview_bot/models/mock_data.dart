import 'knowledge.dart';

final List<Knowledge> knowledgeList = [
  Knowledge(title: 'Knowledge 1', unitList: unitList),
  Knowledge(title: 'Knowledge 2', unitList: cloneUnitList(unitList)),
  Knowledge(title: 'Knowledge 3', unitList: cloneUnitList(unitList)),
  Knowledge(title: 'Knowledge 4', unitList: cloneUnitList(unitList)),
];

List<Unit> cloneUnitList(List<Unit> original) {
  return original.map((unit) => Unit(
    name: unit.name,
    isEnabled: unit.isEnabled,
    source: unit.source,
    creationDate: unit.creationDate,
    size: unit.size,
  )).toList();
}

final List<Unit> unitList = [
  Unit(
      name: 'Unit 1',
      isEnabled: true,
      source: dataSourceOptions[0],
      creationDate: DateTime(2021, 10, 10),
      size: '1.2 MB'),
  Unit(
      name: 'Unit 2',
      isEnabled: true,
      source: dataSourceOptions[1],
      creationDate: DateTime(2023, 10, 10),
      size: '1.6 MB'),
  Unit(
      name: 'Unit 3',
      isEnabled: true,
      source: dataSourceOptions[2],
      creationDate: DateTime(2022, 10, 10),
      size: '26 MB'),
  Unit(
      name: 'Unit 4',
      isEnabled: false,
      source: dataSourceOptions[3],
      creationDate: DateTime(2021, 15, 13),
      size: '14 MB'),
  Unit(
      name: 'Unit 5',
      isEnabled: true,
      source: dataSourceOptions[4],
      creationDate: DateTime(2021, 12, 13),
      size: '0.5 MB'),
];

final List<DataSource> dataSourceOptions = [
  DataSource(
    title: 'Local files',
    subtitle: 'Upload pdf, docx, ...',
    imagePath: 'assets/unit/file.png',
  ),
  DataSource(
    title: 'Website',
    subtitle: 'Connect Website to get data',
    imagePath: 'assets/unit/web.png',
  ),
  DataSource(
    title: 'Github repositories',
    subtitle: 'Connect Github repositories to get data',
    imagePath: 'assets/unit/github.png',
  ),
  DataSource(
    title: 'Gitlab repositories',
    subtitle: 'Connect Gitlab repositories to get data',
    imagePath: 'assets/unit/gitlab.png',
  ),
  DataSource(
    title: 'Google Drive',
    subtitle: 'Connect Google drive to get data',
    imagePath: 'assets/unit/google_drive.png',
  ),
  DataSource(
    title: 'Slack',
    subtitle: 'Connect Slack to get data',
    imagePath: 'assets/unit/slack.png',
  ),
  DataSource(
    title: 'Confluence',
    subtitle: 'Connect Confluence to get data',
    imagePath: 'assets/unit/confluence.png',
  ),
  DataSource(
    title: 'Jira',
    subtitle: 'Connect Jira to get data',
    imagePath: 'assets/unit/jira.png',
  ),
  DataSource(
    title: 'Hubspot',
    subtitle: 'Connect Hubspot to get data',
    imagePath: 'assets/unit/hubspot.png',
  ),
  DataSource(
    title: 'Linear',
    subtitle: 'Connect Linear to get data',
    imagePath: 'assets/unit/linear.png',
  ),
  DataSource(
    title: 'Notion',
    subtitle: 'Connect Notion to get data',
    imagePath: 'assets/unit/notion.png',
  ),
];
