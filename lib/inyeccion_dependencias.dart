import 'package:conquistadores_app/funcionalidades/autenticacion/dominio/entidades/repositorio_autenticacion.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/red/cliente_http.dart';
import 'funcionalidades/autenticacion/data/repositorio_autenticacion_impl.dart';
import 'funcionalidades/autenticacion/dominio/casos_uso/login_usuario.dart';
import 'funcionalidades/autenticacion/presentacion/bloc/autenticacion_bloc.dart';

final sl = GetIt.instance;

Future<void> inicializarDependencias() async {
  // Externos
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Core
  sl.registerLazySingleton(() => ClienteHttp(sl<Dio>()));

  // Repositorios
  sl.registerLazySingleton<RepositorioAutenticacion>(
    () => RepositorioAutenticacionImpl(sl<Dio>()),
  );

  // Casos de uso
  sl.registerLazySingleton(() => LoginUsuario(sl()));

  // BLoCs
  sl.registerFactory(
    () => AutenticacionBloc(
      loginUsuario: sl(),
      storage: sl(),
    ),
  );
}
