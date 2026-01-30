import 'package:minio/minio.dart';

class MinioService {
  late Minio _minioClient;

  MinioService() {
    _minioClient = Minio(
      endPoint: '192.168.1.135',
      port: 9000,
      accessKey: 'admin',
      secretKey: 'admin123',
      useSSL: false,
    );
  }

  Future<String> getPresignedUrl(String bucket, String object) async {
    try {
      final url = await _minioClient.presignedGetObject(bucket, object);
      return url;
    } catch (e) {
      throw Exception('Error generating presigned URL: $e');
    }
  }

  String extractBucketAndObject(String imageUrl) {
    // imageUrl: http://192.168.1.134:9000/publicaciones/628d2a03-0f49-46fe-b069-ec3c48554256/0086469f-8a32-451b-9884-018eb4c4ba0a.jpg
    // Remove http://192.168.1.134:9000/
    final path = imageUrl.replaceFirst('http://192.168.1.135:9000/', '');
    // Split by /
    final parts = path.split('/');
    if (parts.length < 2) {
      throw Exception('Invalid image URL format');
    }
    final bucket = parts[0];
    final object = parts.sublist(1).join('/');
    return '$bucket|$object';
  }

  Future<String> getImageUrl(String imageUrl) async {
    final bucketObject = extractBucketAndObject(imageUrl);
    final parts = bucketObject.split('|');
    final bucket = parts[0];
    final object = parts[1];
    return await getPresignedUrl(bucket, object);
  }
}