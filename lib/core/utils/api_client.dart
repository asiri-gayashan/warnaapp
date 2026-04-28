import 'package:dio/dio.dart';
import 'package:warna_app/features/auth/logic/auth_service.dart';
import 'token_service.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5001/api',
  ));

  static Dio get instance {
    _dio.interceptors.clear();
    _dio.interceptors.add(AuthInterceptor());
    return _dio;
  }
}

class AuthInterceptor extends Interceptor {

  // Runs before EVERY request — attaches the token
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenService.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options); // continue the request
  }

  // Runs when response comes back
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    
    // If server says token expired (401), try to refresh
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefresh();

      if (refreshed) {
        // Retry the original request with new token
        final newToken = await TokenService.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

        final retryResponse = await ApiClient.instance.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } else {
        
        AuthService.logoutUser(); // pass null since we might not have a context here
      }
    }

    handler.next(err);
  }

  Future<bool> _tryRefresh() async {
    try {
      final refreshToken = await TokenService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        'http://10.0.2.2:5001/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      await TokenService.saveTokens(
        accessToken:  response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );

      return true;
    } catch (_) {
      return false;
    }
  }
}



// Example API calls using ApiClient

// await ApiClient.instance.delete('/user/delete');


// ApiClient.instance.get('/user/profile');


// await ApiClient.instance.put(
//   '/user/update',
//   data: {
//     'name': 'Asiri',
//   },
// );

// final response = await ApiClient.instance.post(
//   '/auth/login',
//   data: {
//     'email': email,
//     'password': password,
//   },
// );

// print(response.data);




// // GET request — token is attached automatically
// Future<void> getUserProfile() async {
//   try {
//     final response = await ApiClient.instance.get('/user/profile');
//     print(response.data);
//   } on DioException catch (e) {
//     print('Error: ${e.response?.data}');
//   }
// }

// // POST request — same thing
// Future<void> createPost(String title, String body) async {
//   final response = await ApiClient.instance.post('/posts', data: {
//     'title': title,
//     'body': body,
//   });
//   print(response.data);
// }

