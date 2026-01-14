import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'funcionalidades/autenticacion/data/repositorio_autenticacion_impl.dart';
import 'funcionalidades/autenticacion/dominio/repositorio_autenticacion.dart';
import 'funcionalidades/autenticacion/dominio/casos_uso/login_usuario.dart';
import 'funcionalidades/autenticacion/presentacion/bloc/autenticacion_bloc.dart';

final sl = GetIt.instance;

Future<void> inicializarDependencias() async {
  // ---------------------------------------------------------------------------
  // EXTERNOS
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ---------------------------------------------------------------------------
  // HTTP CLIENT (Dio configurado CORRECTAMENTE)
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8082/api/v1', // ANDROID EMULATOR
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );

    return dio;
  });

  // ---------------------------------------------------------------------------
  // REPOSITORIOS
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<RepositorioAutenticacion>(
    () => RepositorioAutenticacionImpl(sl<Dio>() , sl<FlutterSecureStorage>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // CASOS DE USO
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton(
    () => LoginUsuario(sl<RepositorioAutenticacion>()),
  );

  // ---------------------------------------------------------------------------
  // BLOCS
  // ---------------------------------------------------------------------------

  sl.registerFactory(
    () => AutenticacionBloc(
      loginUsuario: sl<LoginUsuario>(),
      storage: sl<FlutterSecureStorage>(),
    ),
  );
}
