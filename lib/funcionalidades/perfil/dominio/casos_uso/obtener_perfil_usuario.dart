import 'package:conquistadores_app/funcionalidades/autenticacion/dominio/entidades/usuario.dart';

import '../entidades/perfil.dart';

import '../repositorio_perfil.dart';

class ObtenerPerfilUsuario {
  final RepositorioPerfil repositorio;

  ObtenerPerfilUsuario(this.repositorio);

  Future<Perfil> ejecutar() {
    return repositorio.obtenerPerfilUsuario();
  }
}