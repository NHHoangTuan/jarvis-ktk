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
  GEMINI_1_5_FLASH_LATEST,
  GEMINI_1_5_PRO_LATEST,
  GPT_4O,
  GPT_4O_MINI
}

extension AssistantIdExtension on AssistantId {
  String get name {
    switch (this) {
      case AssistantId.CLAUDE_3_5_SONNET_20240620:
        return "claude-3-5-sonnet-20240620";
      case AssistantId.CLAUDE_3_HAIKU_20240307:
        return "claude-3-haiku-20240307";
      case AssistantId.GEMINI_1_5_FLASH_LATEST:
        return "gemini-1.5-flash-latest";
      case AssistantId.GEMINI_1_5_PRO_LATEST:
        return "gemini-1.5-pro-latest";
      case AssistantId.GPT_4O:
        return "gpt-4o";
      case AssistantId.GPT_4O_MINI:
        return "gpt-4o-mini";
      default:
        return "";
    }
  }
}

///Always is "dify"
enum AssistantModel { DIFY }

extension AssistantModelExtension on AssistantModel {
  String get name => "dify";
}
