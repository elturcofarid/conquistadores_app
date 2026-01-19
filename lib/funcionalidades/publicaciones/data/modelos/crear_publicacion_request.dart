class CrearPublicacionRequest {
  final String descripcion;
  final double? longitud;
  final double? latitud;
  final String imagenBase64;

  CrearPublicacionRequest({
    required this.descripcion,
    this.longitud,
    this.latitud,
    required this.imagenBase64,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'descripcion': descripcion,
      'imagenBase64': imagenBase64,
    };
    if (longitud != null) map['longitud'] = longitud;
    if (latitud != null) map['latitud'] = latitud;
    return map;
  }
}