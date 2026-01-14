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
    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return response.data['accessToken'];
  }
  
  @override
  Future<void> registrar({required String email, required String username, required String password, required String paisOrigen}) {
    // TODO: implement registrar
    throw UnimplementedError();
  }
}
