class ApiEndpoints {
  static const String baseUrl = 'https://api.dev.jarvis.cx/api/v1';

  // Auth
  static const String signIn = 'auth/sign-in';
  static const String signUp = 'auth/sign-up';
  static const String refreshToken = 'auth/refresh';
  static const String signOut = 'auth/sign-out';
  static const String me = 'auth/me';

  // Chat


  // Prompt
  static const String prompts = 'prompts';
  static const String promptById = 'prompts/{id}';
  static const String promptFavorite = 'prompts/{id}/favorite';

}
