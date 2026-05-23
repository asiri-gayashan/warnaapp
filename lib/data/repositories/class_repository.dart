import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class ClassRepository {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>?> getClasses() async {
    try {
      final response = await _dio.get("/classes/");
      return response.data['data'];
    } on DioException catch (error) {
      print(error);
      return null;
    }
  }

 
}