import 'package:dio/dio.dart';

class DioClient {
  DioClient._(); // private constructor - outside කෙනෙකුට new DioClient() කරන්න බෑ

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:5001/api",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );
}
