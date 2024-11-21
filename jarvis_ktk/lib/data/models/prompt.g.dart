// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prompt _$PromptFromJson(Map<String, dynamic> json) => Prompt(
      title: json['title'] as String,
      content: json['content'] as String,
    )..id = json['_id'] as String?;

Map<String, dynamic> _$PromptToJson(Prompt instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'content': instance.content,
    };

MyPrompt _$MyPromptFromJson(Map<String, dynamic> json) => MyPrompt(
      title: json['title'] as String,
      content: json['content'] as String,
    )..id = json['_id'] as String?;

Map<String, dynamic> _$MyPromptToJson(MyPrompt instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'content': instance.content,
    };

PublicPrompt _$PublicPromptFromJson(Map<String, dynamic> json) => PublicPrompt(
      category: json['category'] as String,
      userName: json['userName'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? true,
      title: json['title'] as String,
      content: json['content'] as String,
      userId: json['userId'] as String?,
    )..id = json['_id'] as String?;

Map<String, dynamic> _$PublicPromptToJson(PublicPrompt instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'description': instance.description,
      'language': instance.language,
      'isFavorite': instance.isFavorite,
      'userName': instance.userName,
      'userId': instance.userId,
    };
