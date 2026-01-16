import 'package:conquistadores_app/funcionalidades/autenticacion/dominio/entidades/usuario.dart';
import 'package:conquistadores_app/funcionalidades/perfil/dominio/entidades/perfil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dominio/casos_uso/obtener_perfil_usuario.dart';
import 'perfil_estado.dart';
import 'perfil_evento.dart';

class PerfilBloc extends Bloc<PerfilEvento, PerfilEstado> {
  final ObtenerPerfilUsuario obtenerPerfilUsuario;

  PerfilBloc(this.obtenerPerfilUsuario) : super(PerfilInicial()) {
    on<CargarPerfil>(_onCargarPerfil);
  }

  Future<void> _onCargarPerfil(CargarPerfil event, Emitter<PerfilEstado> emit) async {
    emit(PerfilCargando());

    try {
      final perfil = await obtenerPerfilUsuario.ejecutar();
      emit(PerfilCargado(perfil));
    } catch (e) {
      emit(PerfilError('Error al cargar perfil'));
    }
  }
}