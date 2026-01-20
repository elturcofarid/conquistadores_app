
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterceptorJwt extends Interceptor {
  final SharedPreferences storage;

  InterceptorJwt(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    print('Interceptor JWT: Path = ${options.path}');
    if (options.path.startsWith('/v1/auth')) {
      print('Interceptor JWT: Skipping auth endpoint');
      // Ensure no Authorization header for auth endpoints
      options.headers.remove('Authorization');
      return handler.next(options);
    }

    final token = storage.getString('access_token');
    if (token != null) {
      print('Interceptor JWT: Adding token to request');
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      print('Interceptor JWT: No token found');
    }
    super.onRequest(options, handler);
  }
}

  