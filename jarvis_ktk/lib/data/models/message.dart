class MessageData {
  final String role;
  final int createdAt;
  final List<MessageContent> content;

  MessageData({
    required this.role,
    required this.createdAt,
    required this.content,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      role: json['role'],
      createdAt: json['createdAt'],
      content: List<MessageContent>.from(
        json['content'].map((x) => MessageContent.fromJson(x)),
      ),
    );
  }
}

class MessageContent {
  final String type;
  final MessageText text;

  MessageContent({
    required this.type,
    required this.text,
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(
      type: json['type'],
      text: MessageText.fromJson(json['text']),
    );
  }
}

class MessageText {
  final String value;
  final List<dynamic> annotations;

  MessageText({
    required this.value,
    required this.annotations,
  });

  factory MessageText.fromJson(Map<String, dynamic> json) {
    return MessageText(
      value: json['value'],
      annotations: json['annotations'],
    );
  }
}
