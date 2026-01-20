class PublicacionListResponse {
  final String id;
  final String descripcion;
  final String imagenUrl;
  final double? longitud;
  final double? latitud;
  final DateTime fechaCreacion;
  final UsuarioSummary usuario;

  PublicacionListResponse({
    required this.id,
    required this.descripcion,
    required this.imagenUrl,
    this.longitud,
    this.latitud,
    required this.fechaCreacion,
    required this.usuario,
  });

  factory PublicacionListResponse.fromJson(Map<String, dynamic> json) {
    return PublicacionListResponse(
      id: json['id'],
      descripcion: json['descripcion'],
      imagenUrl: json['imagenUrl'],
      longitud: json['longitud'],
      latitud: json['latitud'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      usuario: UsuarioSummary.fromJson(json['usuario']),
    );
  }
}

class UsuarioSummary {
  final String id;
  final String nombre;
  final String? avatarUrl;

  UsuarioSummary({
    required this.id,
    required this.nombre,
    this.avatarUrl,
  });

  factory UsuarioSummary.fromJson(Map<String, dynamic> json) {
    return UsuarioSummary(
      id: json['id'],
      nombre: json['nombre'],
      avatarUrl: json['avatarUrl'],
    );
  }
}