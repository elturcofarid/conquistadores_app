
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterceptorJwt extends Interceptor {
  final SharedPreferences storage;

  InterceptorJwt(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    if (options.path.startsWith('/auth')) {
      return handler.next(options);
    }

    final token = storage.getString('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

  