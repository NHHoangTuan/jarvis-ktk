// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenUsage _$TokenUsageFromJson(Map<String, dynamic> json) => TokenUsage(
      availableTokens: (json['availableTokens'] as num).toInt(),
      totalTokens: (json['totalTokens'] as num).toInt(),
      unlimited: json['unlimited'] as bool,
    );

Map<String, dynamic> _$TokenUsageToJson(TokenUsage instance) =>
    <String, dynamic>{
      'availableTokens': instance.availableTokens,
      'totalTokens': instance.totalTokens,
      'unlimited': instance.unlimited,
    };
