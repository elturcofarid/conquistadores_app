import '../../dominio/entidades/perfil.dart';

class PerfilModel extends Perfil {
  PerfilModel.fromJson(Map<String, dynamic> json)
      : super(
          userId: json['userId'],
          puntaje: json['puntaje'],
          rango: json['rango'],
          biografia: json['biografia'],
          fotoUrl: json['fotoUrl'],
          lugaresVisitados: (json['lugaresVisitados'] as List<dynamic>?)
              ?.map((e) => LugarVisitado.fromJson(e))
              .toList() ?? [],
        );
}