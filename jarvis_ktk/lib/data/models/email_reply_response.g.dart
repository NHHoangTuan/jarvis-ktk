// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_reply_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailReplyResponse _$EmailReplyResponseFromJson(Map<String, dynamic> json) =>
    EmailReplyResponse(
      email: json['email'] as String,
      remainingUsage: (json['remainingUsage'] as num).toInt(),
    );

Map<String, dynamic> _$EmailReplyResponseToJson(EmailReplyResponse instance) =>
    <String, dynamic>{
      'email': instance.email,
      'remainingUsage': instance.remainingUsage,
    };
