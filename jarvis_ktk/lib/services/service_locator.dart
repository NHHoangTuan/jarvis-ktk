import 'package:get_it/get_it.dart';
import '../data/network/api_service.dart';
import '../data/network/auth_api.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerFactory(() => AuthApi(getIt<ApiService>()));
}