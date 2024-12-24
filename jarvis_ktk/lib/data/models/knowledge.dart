import 'package:json_annotation/json_annotation.dart';

part 'knowledge.g.dart';

@JsonSerializable()
class Knowledge {
  final String knowledgeName;
  final String userId;
  final String id;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  DateTime? deletedAt;
  int numUnits = 0;
  int totalSize = 0;
  List<Unit> unitList;

  Knowledge(
      this.userId, this.id, this.description, this.createdAt, this.updatedAt,
      {required this.knowledgeName, this.unitList = const []});

  factory Knowledge.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeFromJson(json);

  Map<String, dynamic> toJson() => _$KnowledgeToJson(this);
}

@JsonSerializable()
class Unit {
  final String userId;
  final String id;
  final String knowledgeId;
  final String name;
  final DataSourceType type;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool status;

  Unit(
      {required this.userId,
      required this.id,
      required this.knowledgeId,
      required this.name,
      required this.type,
      required this.size,
      required this.createdAt,
      required this.updatedAt,
      required this.status,
      });

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}

enum DataSourceType {
  local_file,
  google_drive,
  slack,
  confluence,
  web,
}

DataSource dataSourceTypeToString(DataSourceType type) {
  switch (type) {
    case DataSourceType.local_file:
      return DataSource(
        title: 'Local files',
        subtitle: 'Upload pdf, docx, ...',
        imagePath: 'assets/unit/file.png',
        type: DataSourceType.local_file,
      );
    case DataSourceType.google_drive:
      return DataSource(
        title: 'Google Drive',
        subtitle: 'Connect Google drive to get data',
        imagePath: 'assets/unit/google_drive.png',
        type: DataSourceType.google_drive,
      );
    case DataSourceType.slack:
      return DataSource(
        title: 'Slack',
        subtitle: 'Connect Slack to get data',
        imagePath: 'assets/unit/slack.png',
        type: DataSourceType.slack,
      );
    case DataSourceType.confluence:
      return DataSource(
        title: 'Confluence',
        subtitle: 'Connect Confluence to get data',
        imagePath: 'assets/unit/confluence.png',
        type: DataSourceType.confluence,
      );
    case DataSourceType.web:
      return DataSource(
        title: 'Website',
        subtitle: 'Connect Website to get data',
        imagePath: 'assets/unit/web.png',
        type: DataSourceType.web,
      );
  }
}

class DataSource {
  final String title;
  final String subtitle;
  final String imagePath;
  final DataSourceType type;

  DataSource({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.type,
  });
}
