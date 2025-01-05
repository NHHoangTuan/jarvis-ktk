import 'package:json_annotation/json_annotation.dart';

part 'email_suggest_idea_response.g.dart';

@JsonSerializable()
class EmailSuggestIdeaResponse {
  final List<String> ideas;

  EmailSuggestIdeaResponse({
    required this.ideas,
  });

  factory EmailSuggestIdeaResponse.fromJson(Map<String, dynamic> json) => _$EmailSuggestIdeaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmailSuggestIdeaResponseToJson(this);
}