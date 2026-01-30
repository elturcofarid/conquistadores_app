import 'package:minio/minio.dart';

class MinioService {
  late Minio _minioClient;

  MinioService() {
    _minioClient = Minio(
      endPoint: '192.168.1.134',
      port: 9000,
      accessKey: 'admin',
      secretKey: 'admin123',
      useSSL: false,
    );
  }

  Future<String> getPresignedUrl(String bucket, String object) async {
    print('getPresignedUrl called with bucket: $bucket, object: $object');
    try {
      final url = await _minioClient.presignedGetObject(bucket, object);
      print('Generated presigned URL: $url');
      return url;
    } catch (e) {
      print('Error in getPresignedUrl: $e');
      throw Exception('Error generating presigned URL: $e');
    }
  }

  String extractBucketAndObject(String imageUrl) {
    // Assuming imageUrl is the path after bucket, like '628d2a03-0f49-46fe-b069-ec3c48554256/0086469f-8a32-451b-9884-018eb4c4ba0a.jpg'
    print('Original imageUrl: $imageUrl');
    final bucket = 'publicaciones';
    final object = imageUrl;
    print('Extracted bucket: $bucket, object: $object');
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