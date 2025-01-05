// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_suggest_idea_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailSuggestIdeaResponse _$EmailSuggestIdeaResponseFromJson(
        Map<String, dynamic> json) =>
    EmailSuggestIdeaResponse(
      ideas: (json['ideas'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$EmailSuggestIdeaResponseToJson(
        EmailSuggestIdeaResponse instance) =>
    <String, dynamic>{
      'ideas': instance.ideas,
    };
