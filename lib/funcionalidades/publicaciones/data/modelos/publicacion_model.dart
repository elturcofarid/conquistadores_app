import '../../dominio/entidades/publicacion.dart';

class PublicacionModel extends Publicacion {
  PublicacionModel.fromJson(Map<String, dynamic> json)
      : super(
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