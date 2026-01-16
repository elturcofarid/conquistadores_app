class LugarVisitado {
  final String placeId;

  LugarVisitado({required this.placeId});

  factory LugarVisitado.fromJson(Map<String, dynamic> json) {
    return LugarVisitado(placeId: json['placeId']);
  }
}

class Perfil {
  final String userId;
  final int puntaje;
  final String rango;
  final String? biografia;
  final String? fotoUrl;
  final List<LugarVisitado> lugaresVisitados;

  Perfil({
    required this.userId,
    required this.puntaje,
    required this.rango,
    this.biografia,
    this.fotoUrl,
    required this.lugaresVisitados,
  });
}