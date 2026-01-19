import 'package:equatable/equatable.dart';

abstract class PublicacionEstado extends Equatable {
  const PublicacionEstado();

  @override
  List<Object?> get props => [];
}

class PublicacionInicial extends PublicacionEstado {
  final String? imagenBase64;
  final String descripcion;
  final double? longitud;
  final double? latitud;

  const PublicacionInicial({
    this.imagenBase64,
    this.descripcion = '',
    this.longitud,
    this.latitud,
  });

  @override
  List<Object?> get props => [imagenBase64, descripcion, longitud, latitud];
}

class PublicacionCargando extends PublicacionEstado {}

class PublicacionCreada extends PublicacionEstado {}

class PublicacionError extends PublicacionEstado {
  final String mensaje;

  const PublicacionError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}