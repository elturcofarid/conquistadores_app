import 'package:conquistadores_app/funcionalidades/autenticacion/dominio/entidades/repositorio_autenticacion.dart';
import 'package:dio/dio.dart';

class RepositorioAutenticacionImpl implements RepositorioAutenticacion {
  final Dio dio;

  RepositorioAutenticacionImpl(this.dio);

  @override
  Future<void> registrar({
    required String email,
    required String username,
    required String password,
    required String paisOrigen,
  }) async {
    await dio.post('/auth/register', data: {
      'email': email,
      'username': username,
      'password': password,
      'paisOrigen': paisOrigen,
    });
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    return response.data['accessToken'];
  }
}
