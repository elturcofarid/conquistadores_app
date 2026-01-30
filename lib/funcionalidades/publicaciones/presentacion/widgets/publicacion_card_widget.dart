import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../data/modelos/publicacion_list_response.dart';
import '../../../../core/minio/minio_service.dart';

class PublicacionCardWidget extends StatelessWidget {
  final PublicacionListResponse publicacion;

  const PublicacionCardWidget({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    final minioService = GetIt.instance<MinioService>();
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<String>(
            future: minioService.getImageUrl(publicacion.imagenUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                );
              } else {
                return Image.network(
                  snapshot.data!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  publicacion.descripcion,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${publicacion.usuario.nombre} • ${publicacion.fechaCreacion.toLocal()}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (publicacion.longitud != null && publicacion.latitud != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Ubicación: ${publicacion.latitud!.toStringAsFixed(4)}, ${publicacion.longitud!.toStringAsFixed(4)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}