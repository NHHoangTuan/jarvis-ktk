import 'package:json_annotation/json_annotation.dart';

part 'prompt.g.dart';

@JsonSerializable()
class Prompt {
  @JsonKey(name: '_id')
  String id;
  String title;
  String content;

  Prompt({required this.title, required this.content, this.id = ''});

  factory Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);

  Map<String, dynamic> toJson() => _$PromptToJson(this);
}

@JsonSerializable()
class MyPrompt extends Prompt {
  MyPrompt({required super.title, required super.content, super.id});

  factory MyPrompt.fromJson(Map<String, dynamic> json) =>
      _$MyPromptFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MyPromptToJson(this);
}

@JsonSerializable()
class PublicPrompt extends Prompt {
  String? category;
  String? description;
  String? language;
  bool isFavorite;
  final String? userName;
  final String? userId;

  PublicPrompt({
    this.category,
    this.userName,
    this.description,
    this.language,
    this.isFavorite = true,
    required super.title,
    required super.content,
    this.userId,
    super.id,
  });

  factory PublicPrompt.fromJson(Map<String, dynamic> json) =>
      _$PublicPromptFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PublicPromptToJson(this);
}
