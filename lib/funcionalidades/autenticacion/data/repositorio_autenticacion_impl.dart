import 'package:conquistadores_app/funcionalidades/autenticacion/dominio/repositorio_autenticacion.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RepositorioAutenticacionImpl implements RepositorioAutenticacion {
  final Dio dio;
  final FlutterSecureStorage storage;

  RepositorioAutenticacionImpl(this.dio, this.storage);

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    print('Intentando login con email: $email');
    print('URL base: ${dio.options.baseUrl}');
    print('Endpoint completo: ${dio.options.baseUrl}/auth/login');
    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    print('Respuesta recibida: ${response.data}');
    return response.data['accessToken'];
  }
  
  @override
  Future<void> registrar({required String email, required String username, required String password, required String paisOrigen}) {
    // TODO: implement registrar
    throw UnimplementedError();
  }
}
