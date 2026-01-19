import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/casos_uso/crear_publicacion.dart';
import 'publicacion_evento.dart';
import 'publicacion_estado.dart';

class PublicacionBloc extends Bloc<PublicacionEvento, PublicacionEstado> {
  final CrearPublicacion crearPublicacion;

  PublicacionBloc({required this.crearPublicacion})
      : super(const PublicacionInicial()) {
    on<ImagenSeleccionada>(_onImagenSeleccionada);
    on<DescripcionCambiada>(_onDescripcionCambiada);
    on<CrearPublicacionSolicitado>(_onCrearPublicacionSolicitado);
  }

  void _onImagenSeleccionada(
    ImagenSeleccionada event,
    Emitter<PublicacionEstado> emit,
  ) {
    if (state is PublicacionInicial) {
      final currentState = state as PublicacionInicial;
      emit(PublicacionInicial(
        imagenBase64: event.imagenBase64,
        descripcion: currentState.descripcion,
        longitud: event.longitud,
        latitud: event.latitud,
      ));
    }
  }

  void _onDescripcionCambiada(
    DescripcionCambiada event,
    Emitter<PublicacionEstado> emit,
  ) {
    if (state is PublicacionInicial) {
      final currentState = state as PublicacionInicial;
      emit(PublicacionInicial(
        imagenBase64: currentState.imagenBase64,
        descripcion: event.descripcion,
        longitud: currentState.longitud,
        latitud: currentState.latitud,
      ));
    }
  }

  Future<void> _onCrearPublicacionSolicitado(
    CrearPublicacionSolicitado event,
    Emitter<PublicacionEstado> emit,
  ) async {
    if (state is PublicacionInicial) {
      final currentState = state as PublicacionInicial;
      if (currentState.imagenBase64 == null || currentState.descripcion.isEmpty) {
        emit(const PublicacionError('Selecciona una imagen y escribe una descripción'));
        return;
      }

      emit(PublicacionCargando());

      try {
        await crearPublicacion.ejecutar(
          currentState.descripcion,
          currentState.imagenBase64!,
          longitud: currentState.longitud,
          latitud: currentState.latitud,
        );
        emit(PublicacionCreada());
      } catch (e) {
        emit(PublicacionError('Error al crear la publicación: $e'));
      }
    }
  }
}