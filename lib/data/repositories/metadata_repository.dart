import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';

class MetadataRepository {
  final Dio _dio = DioClient.instance;

  Future<List<dynamic>?> getDistricts() async {
    try {
      final response = await _dio.get("/metadata/get-district");
      return response.data['data'];
    } on DioException catch (error) {
      print(error);
      return null;
    }
  }

  Future<List<dynamic>?> getSubjects() async {
    try {
      final response = await _dio.get("/metadata/get-subject");
      return response.data['data'];
    } on DioException catch (error) {
      print(error);
      return null;
    }
  }
}