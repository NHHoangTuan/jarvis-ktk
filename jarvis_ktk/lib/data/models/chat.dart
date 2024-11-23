class ChatHistory {
  final String answer;
  final int createdAt;
  final List<String> files;
  final String query;

  ChatHistory({
    required this.answer,
    required this.createdAt,
    required this.files,
    required this.query,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      answer: json['answer'] ?? '',
      createdAt: json['createdAt'] ?? 0,
      files: List<String>.from(json['files'] ?? []),
      query: json['query'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'createdAt': createdAt,
      'files': files,
      'query': query,
    };
  }
}

class Conversation {
  final String id;
  final String title;
  final int createdAt;

  Conversation({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      createdAt: json['createdAt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt,
    };
  }
}

enum AssistantId {
  CLAUDE_3_5_SONNET_20240620,
  CLAUDE_3_HAIKU_20240307,
  GEMINI_15_FLASH_LATEST,
  GEMINI_15_PRO_LATEST,
  GPT_4O,
  GPT_4O_MINI
}

final assistantIdValues = EnumValues({
  "claude-3-5-sonnet-20240620": AssistantId.CLAUDE_3_5_SONNET_20240620,
  "claude-3-haiku-20240307": AssistantId.CLAUDE_3_HAIKU_20240307,
  "gemini-1.5-flash-latest": AssistantId.GEMINI_15_FLASH_LATEST,
  "gemini-1.5-pro-latest": AssistantId.GEMINI_15_PRO_LATEST,
  "gpt-4o": AssistantId.GPT_4O,
  "gpt-4o-mini": AssistantId.GPT_4O_MINI
});

///Always is "dify"
enum AssistantModel { DIFY }

final assistantModelValues = EnumValues({"dify": AssistantModel.DIFY});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}

String toEnumString(dynamic enumValue) {
  return enumValue
      .toString()
      .toLowerCase()
      .replaceAll('_', '-')
      .replaceAll('assistantid.', '');
}

extension EnumString on AssistantId {
  String get name => toEnumString(this);
}

String toEnumStringDify(dynamic enumValue) {
  if (enumValue
      .toString()
      .toLowerCase()
      .replaceAll('assistantmodel.', '')
      .contains('5')) {
    return insertAfterCharacter(
        enumValue.toString().toLowerCase().replaceAll('assistantmodel.', ''),
        '5',
        '.');
  }
  return enumValue.toString().toLowerCase().replaceAll('assistantmodel.', '');
}

extension EnumStringModel on AssistantModel {
  String get name => toEnumStringDify(this);
}

String insertAfterCharacter(String input, String target, String insert) {
  StringBuffer result = StringBuffer();

  for (int i = 0; i < input.length; i++) {
    result.write(input[i]);
    if (input[i] == target) {
      result.write(insert);
    }
  }

  return result.toString();
}
