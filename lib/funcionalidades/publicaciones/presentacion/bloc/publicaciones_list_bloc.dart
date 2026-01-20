import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/modelos/publicacion_list_response.dart';
import '../../dominio/casos_uso/obtener_publicaciones.dart';
import 'publicaciones_list_evento.dart';
import 'publicaciones_list_estado.dart';

class PublicacionesListBloc extends Bloc<PublicacionesListEvento, PublicacionesListEstado> {
  final ObtenerPublicaciones obtenerPublicaciones;

  PublicacionesListBloc({required this.obtenerPublicaciones})
      : super(PublicacionesListInicial()) {
    on<CargarPublicaciones>(_onCargarPublicaciones);
    on<RefrescarPublicaciones>(_onRefrescarPublicaciones);
  }

  Future<void> _onCargarPublicaciones(
    CargarPublicaciones event,
    Emitter<PublicacionesListEstado> emit,
  ) async {
    if (state is PublicacionesListCargando) return;

    final currentState = state;
    List<PublicacionListResponse> publicaciones = [];
    if (currentState is PublicacionesListCargadas) {
      publicaciones = List.from(currentState.publicaciones);
    }

    emit(PublicacionesListCargando());

    try {
      final nuevasPublicaciones = await obtenerPublicaciones.ejecutar(
        page: event.page,
        size: event.size,
      );
      publicaciones.addAll(nuevasPublicaciones);
      emit(PublicacionesListCargadas(publicaciones, hasMore: nuevasPublicaciones.length == event.size));
    } catch (e) {
      emit(PublicacionesListError('Error al cargar publicaciones: $e'));
    }
  }

  Future<void> _onRefrescarPublicaciones(
    RefrescarPublicaciones event,
    Emitter<PublicacionesListEstado> emit,
  ) async {
    emit(PublicacionesListCargando());
    try {
      final publicaciones = await obtenerPublicaciones.ejecutar(page: 0, size: 20);
      emit(PublicacionesListCargadas(publicaciones));
    } catch (e) {
      emit(PublicacionesListError('Error al refrescar publicaciones: $e'));
    }
  }
}