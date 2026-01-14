import 'package:equatable/equatable.dart';

abstract class AutenticacionEstado extends Equatable {
  const AutenticacionEstado();

  @override
  List<Object?> get props => [];
}

/// Estado inicial (app recién abierta)
class AutenticacionInicial extends AutenticacionEstado {}

/// Estado mientras se procesa login / registro
class AutenticacionCargando extends AutenticacionEstado {}

/// Usuario autenticado correctamente
class AutenticacionExitosa extends AutenticacionEstado {
  final String token;

  const AutenticacionExitosa(this.token);

  @override
  List<Object?> get props => [token];
}

/// Usuario no autenticado (logout o token inválido)
class AutenticacionNoAutenticada extends AutenticacionEstado {}

/// Error durante autenticación
class AutenticacionError extends AutenticacionEstado {
  final String mensaje;

  const AutenticacionError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}
