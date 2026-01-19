class Publicacion {
  final String id;
  final String idUsuario;
  final String? idLugar;
  final String descripcion;
  final String urlImagen;
  final DateTime fechaPublicacion;
  final int puntaje;
  final bool lugarNuevo;

  Publicacion({
    required this.id,
    required this.idUsuario,
    this.idLugar,
    required this.descripcion,
    required this.urlImagen,
    required this.fechaPublicacion,
    required this.puntaje,
    required this.lugarNuevo,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'],
      idUsuario: json['idUsuario'],
      idLugar: json['idLugar'],
      descripcion: json['descripcion'],
      urlImagen: json['urlImagen'],
      fechaPublicacion: DateTime.parse(json['fechaPublicacion']),
      puntaje: json['puntaje'],
      lugarNuevo: json['lugarNuevo'],
    );
  }
}