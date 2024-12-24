class ApiEndpoints {
  static const String baseUrl = 'https://api.dev.jarvis.cx/api/v1';
  static const String knowledgeBaseUrl =
      'https://knowledge-api.dev.jarvis.cx/kb-core/v1';

  // Auth
  static const String signIn = 'auth/sign-in';
  static const String kbSignIn = 'auth/external-sign-in';
  static const String signUp = 'auth/sign-up';
  static const String refreshToken = 'auth/refresh';
  static const String signOut = 'auth/sign-out';
  static const String me = 'auth/me';

  // Chat
  static const String chatHistory =
      'ai-chat/conversations/{conversationId}/messages';
  static const String chatSend = 'ai-chat/messages';
  static const String chatConversation = 'ai-chat/conversations';

  // Prompt
  static const String prompts = 'prompts';
  static const String promptById = 'prompts/{id}';
  static const String promptFavorite = 'prompts/{id}/favorite';

  // Email
  static const String responseEmail = 'ai-email';
  static const String suggestEmailIdeas = 'ai-email/reply-ideas';

  // Token
  static const String tokenUsage = 'tokens/usage';

  // Knowledge Base

  //// AI Assistant

  static const String createAssistant = 'ai-assistant';
  static const String getAssistants = 'ai-assistant';
  static const String knowledge = 'knowledge';
  static const String knowledgeById = 'knowledge/{id}';
  static const String knowledgeUnits = 'knowledge/{id}/units';
  static const String knowledgeUnitById = 'knowledge/{id}/units/{unitId}';
  static const String knowledgeUnitStatus = 'knowledge/units/{unitId}/status';

  // Unit
  static const String localFileUnit = 'knowledge/{id}/local-file';
  static const String googleDriveUnit = 'knowledge/{id}/google-drive';
  static const String slackUnit = 'knowledge/{id}/slack';
  static const String confluenceUnit = 'knowledge/{id}/confluence';
  static const String webUnit = 'knowledge/{id}/web';
}
