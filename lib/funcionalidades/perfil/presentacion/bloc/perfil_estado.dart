import 'package:conquistadores_app/funcionalidades/autenticacion/dominio/entidades/usuario.dart';
import 'package:conquistadores_app/funcionalidades/perfil/dominio/entidades/perfil.dart';

abstract class PerfilEstado {}

class PerfilInicial extends PerfilEstado {}

class PerfilCargando extends PerfilEstado {}

class PerfilCargado extends PerfilEstado {
  //final Usuario usuario;
final Perfil perfil;
  PerfilCargado(this.perfil);
}

class PerfilError extends PerfilEstado {
  final String mensaje;
  PerfilError(this.mensaje);
}