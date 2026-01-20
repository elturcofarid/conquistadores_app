import 'package:equatable/equatable.dart';
import '../../data/modelos/publicacion_list_response.dart';

abstract class PublicacionesListEstado extends Equatable {
  const PublicacionesListEstado();

  @override
  List<Object?> get props => [];
}

class PublicacionesListInicial extends PublicacionesListEstado {}

class PublicacionesListCargando extends PublicacionesListEstado {}

class PublicacionesListCargadas extends PublicacionesListEstado {
  final List<PublicacionListResponse> publicaciones;
  final bool hasMore;

  const PublicacionesListCargadas(this.publicaciones, {this.hasMore = true});

  @override
  List<Object?> get props => [publicaciones, hasMore];
}

class PublicacionesListError extends PublicacionesListEstado {
  final String mensaje;

  const PublicacionesListError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}