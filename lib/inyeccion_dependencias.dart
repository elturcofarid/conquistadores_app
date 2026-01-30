import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/configuracion/entorno.dart';
import 'core/minio/minio_service.dart';
import 'core/red/interceptor_jwt.dart';
import 'funcionalidades/autenticacion/data/repositorio_autenticacion_impl.dart';
import 'funcionalidades/autenticacion/dominio/repositorio_autenticacion.dart';
import 'funcionalidades/autenticacion/dominio/casos_uso/login_usuario.dart';
import 'funcionalidades/autenticacion/presentacion/bloc/autenticacion_bloc.dart';
import 'funcionalidades/perfil/data/repositorio_perfil_impl.dart';
import 'funcionalidades/perfil/dominio/repositorio_perfil.dart';
import 'funcionalidades/perfil/dominio/casos_uso/obtener_perfil_usuario.dart';
import 'funcionalidades/perfil/presentacion/bloc/perfil_bloc.dart';
import 'funcionalidades/publicaciones/data/repositorio_publicacion_impl.dart';
import 'funcionalidades/publicaciones/dominio/repositorio_publicacion.dart';
import 'funcionalidades/publicaciones/dominio/casos_uso/crear_publicacion.dart';
import 'funcionalidades/publicaciones/dominio/casos_uso/obtener_publicaciones.dart';
import 'funcionalidades/publicaciones/presentacion/bloc/publicacion_bloc.dart';
import 'funcionalidades/publicaciones/presentacion/bloc/publicaciones_list_bloc.dart';

final sl = GetIt.instance;

Future<void> inicializarDependencias() async {
  // ---------------------------------------------------------------------------
  // EXTERNOS
  // ---------------------------------------------------------------------------

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<MinioService>(() => MinioService());
  print('MinioService registered: ${sl.isRegistered<MinioService>()}');

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

   dio.interceptors.add(InterceptorJwt(prefs));

   return dio;
 });

  // ---------------------------------------------------------------------------
  // REPOSITORIOS
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<RepositorioAutenticacion>(
    () => RepositorioAutenticacionImpl(sl<Dio>() , sl<SharedPreferences>(),
    ),
  );

  sl.registerLazySingleton<RepositorioPerfil>(
    () => RepositorioPerfilImpl(sl<Dio>()),
  );

  sl.registerLazySingleton<RepositorioPublicacion>(
    () => RepositorioPublicacionImpl(sl<Dio>()),
  );

  // ---------------------------------------------------------------------------
  // CASOS DE USO
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton(
    () => LoginUsuario(sl<RepositorioAutenticacion>()),
  );

  sl.registerLazySingleton(
    () => ObtenerPerfilUsuario(sl<RepositorioPerfil>()),
  );

  sl.registerLazySingleton(
    () => CrearPublicacion(sl<RepositorioPublicacion>()),
  );

  sl.registerLazySingleton(
    () => ObtenerPublicaciones(sl<RepositorioPublicacion>()),
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

  sl.registerFactory(
    () => PerfilBloc(sl<ObtenerPerfilUsuario>()),
  );

  sl.registerFactory(
    () => PublicacionBloc(crearPublicacion: sl<CrearPublicacion>()),
  );

  sl.registerFactory(
    () => PublicacionesListBloc(obtenerPublicaciones: sl<ObtenerPublicaciones>()),
  );
}
