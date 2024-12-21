// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailReply _$EmailReplyFromJson(Map<String, dynamic> json) => EmailReply(
      mainIdea: json['mainIdea'] as String?,
      action: json['action'] as String,
      email: json['email'] as String,
      metadata:
          EmailMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmailReplyToJson(EmailReply instance) =>
    <String, dynamic>{
      'mainIdea': instance.mainIdea,
      'action': instance.action,
      'email': instance.email,
      'metadata': instance.metadata,
    };

EmailMetadata _$EmailMetadataFromJson(Map<String, dynamic> json) =>
    EmailMetadata(
      mainIdea: json['mainIdea'] as String?,
      context: (json['context'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      subject: json['subject'] as String?,
      sender: json['sender'] as String?,
      receiver: json['receiver'] as String?,
      style: json['style'] == null
          ? null
          : EmailStyle.fromJson(json['style'] as Map<String, dynamic>),
      language: json['language'] as String?,
    );

Map<String, dynamic> _$EmailMetadataToJson(EmailMetadata instance) =>
    <String, dynamic>{
      'context': instance.context,
      'mainIdea': instance.mainIdea,
      'subject': instance.subject,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'style': instance.style,
      'language': instance.language,
    };

EmailStyle _$EmailStyleFromJson(Map<String, dynamic> json) => EmailStyle(
      length: json['length'] as String?,
      formality: json['formality'] as String?,
      tone: json['tone'] as String?,
    );

Map<String, dynamic> _$EmailStyleToJson(EmailStyle instance) =>
    <String, dynamic>{
      'length': instance.length,
      'formality': instance.formality,
      'tone': instance.tone,
    };
