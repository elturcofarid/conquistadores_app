import 'package:conquistadores_app/funcionalidades/autenticacion/dominio/repositorio_autenticacion.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginUsuario {
  final RepositorioAutenticacion repositorio;

  LoginUsuario(this.repositorio);

  Future<String> ejecutar(String email, String password) {
    return repositorio.login(
      email: email,
      password: password,
    );
  }
}
