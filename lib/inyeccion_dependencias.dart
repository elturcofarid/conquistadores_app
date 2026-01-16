import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/configuracion/entorno.dart';
import 'funcionalidades/autenticacion/data/repositorio_autenticacion_impl.dart';
import 'funcionalidades/autenticacion/dominio/repositorio_autenticacion.dart';
import 'funcionalidades/autenticacion/dominio/casos_uso/login_usuario.dart';
import 'funcionalidades/autenticacion/presentacion/bloc/autenticacion_bloc.dart';

final sl = GetIt.instance;

Future<void> inicializarDependencias() async {
  // ---------------------------------------------------------------------------
  // EXTERNOS
  // ---------------------------------------------------------------------------

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ---------------------------------------------------------------------------
  // HTTP CLIENT (Dio configurado CORRECTAMENTE)
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<Dio>(() {
   final dio = Dio(
     BaseOptions(
       baseUrl: ConfiguracionEntorno.baseUrl,
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

   // Add JWT interceptor after SharedPreferences is ready
   // This will be added later when SharedPreferences is available

   return dio;
 });

  // ---------------------------------------------------------------------------
  // REPOSITORIOS
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<RepositorioAutenticacion>(
    () => RepositorioAutenticacionImpl(sl<Dio>() , sl<SharedPreferences>(),
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
      storage: sl<SharedPreferences>(),
    ),
  );
}
