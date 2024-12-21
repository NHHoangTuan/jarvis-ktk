import 'package:json_annotation/json_annotation.dart';

part 'email_reply_response.g.dart';

@JsonSerializable()
class EmailReplyResponse {
  final String email;
  final int remainingUsage;

  EmailReplyResponse({
    required this.email,
    required this.remainingUsage,
  });

  factory EmailReplyResponse.fromJson(Map<String, dynamic> json) => _$EmailReplyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmailReplyResponseToJson(this);
}