
import 'package:flutter_bloc/flutter_bloc.dart';
import 'autenticacion_evento.dart';
import 'autenticacion_estado.dart';
import '../../dominio/casos_uso/login_usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AutenticacionBloc
    extends Bloc<AutenticacionEvento, AutenticacionEstado> {
  final LoginUsuario loginUsuario;
  final FlutterSecureStorage storage;

  AutenticacionBloc({
    required this.loginUsuario,
    required this.storage,
  }) : super(AutenticacionInicial()) {
    on<LoginSolicitado>(_onLoginSolicitado);
    on<LogoutSolicitado>(_onLogoutSolicitado);
  }

  Future<void> _onLoginSolicitado(
    LoginSolicitado event,
    Emitter<AutenticacionEstado> emit,
  ) async {
    emit(AutenticacionCargando());

 print('email: ${event.email}, password: ${event.password}');

    try {
      final token = await loginUsuario.ejecutar(
        event.email,
        event.password,
      );

      print(token);
      print('Token recibido: $token');

      await storage.write(key: 'access_token', value: token);

      emit(AutenticacionExitosa(token));
    } catch (e) {
      print(  'Error durante el login: $e');
      emit(const AutenticacionError(
        'Credenciales inválidas o error de conexión',
      ));
    }
  }

  Future<void> _onLogoutSolicitado(
    LogoutSolicitado event,
    Emitter<AutenticacionEstado> emit,
  ) async {
    await storage.delete(key: 'access_token');
    emit(AutenticacionNoAutenticada());
  }
}
