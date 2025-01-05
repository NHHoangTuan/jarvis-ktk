import 'package:json_annotation/json_annotation.dart';

part 'email_reply.g.dart';

@JsonSerializable()
class EmailReply {
  String? mainIdea;
  final String action;
  String email;
  final EmailMetadata metadata;

  EmailReply({
    this.mainIdea,
    required this.action,
    required this.email,
    required this.metadata,
  });

  factory EmailReply.fromJson(Map<String, dynamic> json) => _$EmailReplyFromJson(json);

  Map<String, dynamic> toJson() => _$EmailReplyToJson(this);
}

@JsonSerializable()
class EmailMetadata {
  final List<String> context;
  final String? mainIdea;
  final String? subject;
  final String? sender;
  final String? receiver;
  final EmailStyle? style;
  final String? language;

  EmailMetadata({
    this.mainIdea,
    this.context = const [],
    this.subject,
    this.sender,
    this.receiver,
    this.style,
    this.language,
  });

  factory EmailMetadata.fromJson(Map<String, dynamic> json) => _$EmailMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$EmailMetadataToJson(this);
}

@JsonSerializable()
class EmailStyle {
  final String? length;
  final String? formality;
  final String? tone;

  EmailStyle({
    this.length,
    this.formality,
    this.tone,
  });

  factory EmailStyle.fromJson(Map<String, dynamic> json) => _$EmailStyleFromJson(json);

  Map<String, dynamic> toJson() => _$EmailStyleToJson(this);
}