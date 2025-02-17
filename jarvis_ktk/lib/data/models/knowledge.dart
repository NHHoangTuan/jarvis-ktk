import 'package:json_annotation/json_annotation.dart';

part 'knowledge.g.dart';

@JsonSerializable()
class Knowledge {
  String knowledgeName;
  final String userId;
  final String id;
  String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  DateTime? deletedAt;
  int? numUnits;
  int? totalSize;

  Knowledge(
      this.userId, this.id, this.description, this.createdAt, this.updatedAt,
      {required this.knowledgeName, this.deletedAt, this.numUnits, this.totalSize});

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
  bool status;
  final Map<String, String> metadata;

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
      required this.metadata
      });

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  Map<String, dynamic> toJson() => _$UnitToJson(this);
}

enum DataSourceType {
  local_file,
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
