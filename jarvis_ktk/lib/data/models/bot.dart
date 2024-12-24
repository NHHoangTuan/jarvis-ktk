// Response sau khi create AI BOT

// {
//     "openAiAssistantId": "asst_RwA0wGMdridSK0bYcImhHhNo",
//     "userId": "9a42a713-fc64-4d43-b94e-30c59036ada8",
//     "assistantName": "KTK BOT 2",
//     "instructions": "You are an assistant of the Jarvis system ...",
//     "description": "This bot is used to ask about the Jarvis system",
//     "openAiThreadIdPlay": "thread_gxK3zajGYPrLv9BfCkpvcjW6",
//     "openAiVectorStoreId": "vs_on3NictGdeGq3wvptdNlp1sN",
//     "isDefault": false,
//     "createdBy": null,
//     "updatedBy": null,
//     "isFavorite": false,
//     "createdAt": "2024-12-24T03:50:09.280Z",
//     "updatedAt": "2024-12-24T03:50:09.280Z",
//     "deletedAt": null,
//     "id": "817d5fd1-d963-4383-a88a-c4015e6c6f84"
// }

class Bot {
  final String openAiAssistantId;
  final String userId;
  final String assistantName;
  final String instructions;
  final String description;
  final String openAiThreadIdPlay;
  final String openAiVectorStoreId;
  final bool isDefault;
  final String? createdBy;
  final String? updatedBy;
  final bool isFavorite;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;
  final String id;

  Bot({
    required this.openAiAssistantId,
    required this.userId,
    required this.assistantName,
    required this.instructions,
    required this.description,
    required this.openAiThreadIdPlay,
    required this.openAiVectorStoreId,
    required this.isDefault,
    required this.createdBy,
    required this.updatedBy,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.id,
  });

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      openAiAssistantId: json['openAiAssistantId'],
      userId: json['userId'],
      assistantName: json['assistantName'],
      instructions: json['instructions'] ?? '',
      description: json['description'] ?? '',
      openAiThreadIdPlay: json['openAiThreadIdPlay'],
      openAiVectorStoreId: json['openAiVectorStoreId'],
      isDefault: json['isDefault'],
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      isFavorite: json['isFavorite'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'] ?? '',
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openAiAssistantId': openAiAssistantId,
      'userId': userId,
      'assistantName': assistantName,
      'instructions': instructions,
      'description': description,
      'openAiThreadIdPlay': openAiThreadIdPlay,
      'openAiVectorStoreId': openAiVectorStoreId,
      'isDefault': isDefault,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'isFavorite': isFavorite,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'id': id,
    };
  }
}
