import 'package:get_it/get_it.dart';
import '../data/network/api_service.dart';
import '../data/network/auth_api.dart';
import '../data/network/prompt_api.dart';
import '../data/network/chat_api.dart';
import '../data/network/token_api.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerFactory(() => AuthApi(getIt<ApiService>()));
  getIt.registerFactory(() => PromptApi(getIt<ApiService>()));
  getIt.registerFactory(() => ChatApi(getIt<ApiService>()));
  getIt.registerFactory(() => TokenApi(getIt<ApiService>()));
}
