import 'package:equatable/equatable.dart';

abstract class AutenticacionEvento extends Equatable {
  const AutenticacionEvento();

  @override
  List<Object?> get props => [];
}

/// Evento cuando el usuario solicita login
class LoginSolicitado extends AutenticacionEvento {
  final String email;
  final String password;

  const LoginSolicitado({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Evento para cerrar sesión
class LogoutSolicitado extends AutenticacionEvento {}
