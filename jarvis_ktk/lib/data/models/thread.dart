class Thread {
  final String openAiThreadId;
  final String assistantId;
  final String threadName;
  final String? createdBy;
  final String? updatedBy;
  final String? integratedPlatform;
  final String? usedUserId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String id;

  Thread({
    required this.openAiThreadId,
    required this.assistantId,
    required this.threadName,
    required this.createdBy,
    required this.updatedBy,
    required this.integratedPlatform,
    required this.usedUserId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.id,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      openAiThreadId: json['openAiThreadId'],
      assistantId: json['assistantId'],
      threadName: json['threadName'],
      integratedPlatform: json['integratedPlatform'] ?? '',
      usedUserId: json['usedUserId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'] ?? '',
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openAiThreadId': openAiThreadId,
      'assistantId': assistantId,
      'threadName': threadName,
      'integratedPlatform': integratedPlatform,
      'usedUserId': usedUserId,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'id': id,
    };
  }
}
