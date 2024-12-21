import 'package:get_it/get_it.dart';
import 'package:jarvis_ktk/data/network/email_api.dart';
import 'package:jarvis_ktk/data/network/knowledge_api_service.dart';
import 'package:jarvis_ktk/data/network/api_service.dart';
import 'package:jarvis_ktk/data/network/auth_api.dart';
import 'package:jarvis_ktk/data/network/knowledge_api.dart';
import 'package:jarvis_ktk/data/network/prompt_api.dart';
import 'package:jarvis_ktk/data/network/chat_api.dart';
import 'package:jarvis_ktk/data/network/token_api.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerCachedFactory(() => KnowledgeApiService());
  getIt.registerCachedFactory(() => AuthApi(getIt<ApiService>()));
  getIt.registerCachedFactory(() => PromptApi(getIt<ApiService>()));
  getIt.registerCachedFactory(() => ChatApi(getIt<ApiService>()));
  getIt.registerCachedFactory(() => EmailApi(getIt<ApiService>()));
  getIt.registerCachedFactory(() => TokenApi(getIt<ApiService>()));
  getIt.registerCachedFactory(() => KnowledgeApi(getIt<KnowledgeApiService>()));
}
