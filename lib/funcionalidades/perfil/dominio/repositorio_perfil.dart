import 'entidades/perfil.dart';

abstract class RepositorioPerfil {
  Future<Perfil> obtenerPerfilUsuario();
}