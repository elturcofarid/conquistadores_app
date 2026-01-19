import 'package:equatable/equatable.dart';

abstract class PublicacionEvento extends Equatable {
  const PublicacionEvento();

  @override
  List<Object?> get props => [];
}

class ImagenSeleccionada extends PublicacionEvento {
  final String imagenBase64;
  final double? longitud;
  final double? latitud;

  const ImagenSeleccionada(this.imagenBase64, {this.longitud, this.latitud});

  @override
  List<Object?> get props => [imagenBase64, longitud, latitud];
}

class DescripcionCambiada extends PublicacionEvento {
  final String descripcion;

  const DescripcionCambiada(this.descripcion);

  @override
  List<Object?> get props => [descripcion];
}

class CrearPublicacionSolicitado extends PublicacionEvento {}