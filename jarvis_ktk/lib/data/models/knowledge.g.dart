// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Knowledge _$KnowledgeFromJson(Map<String, dynamic> json) => Knowledge(
      json['userId'] as String,
      json['id'] as String,
      json['description'] as String,
      DateTime.parse(json['createdAt'] as String),
      DateTime.parse(json['updatedAt'] as String),
      knowledgeName: json['knowledgeName'] as String,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      numUnits: (json['numUnits'] as num?)?.toInt(),
      totalSize: (json['totalSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KnowledgeToJson(Knowledge instance) => <String, dynamic>{
      'knowledgeName': instance.knowledgeName,
      'userId': instance.userId,
      'id': instance.id,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'numUnits': instance.numUnits,
      'totalSize': instance.totalSize,
    };

Unit _$UnitFromJson(Map<String, dynamic> json) => Unit(
      userId: json['userId'] as String,
      id: json['id'] as String,
      knowledgeId: json['knowledgeId'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$DataSourceTypeEnumMap, json['type']),
      size: (json['size'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: json['status'] as bool,
      metadata: Map<String, String>.from(json['metadata'] as Map),
    );

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'knowledgeId': instance.knowledgeId,
      'name': instance.name,
      'type': _$DataSourceTypeEnumMap[instance.type]!,
      'size': instance.size,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': instance.status,
      'metadata': instance.metadata,
    };

const _$DataSourceTypeEnumMap = {
  DataSourceType.local_file: 'local_file',
  DataSourceType.google_drive: 'google_drive',
  DataSourceType.slack: 'slack',
  DataSourceType.confluence: 'confluence',
  DataSourceType.web: 'web',
};
