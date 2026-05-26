import 'package:dio/dio.dart';
import 'package:warna_app/data/models/class_model.dart';
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


  Future<Map<String, dynamic>?> getClassesById(String classId) async {
    try {
      final response = await _dio.get("/classes/$classId");
      // print(response.data["data"]);    
      return response.data['data'];
    } on DioException catch (error) {
      print(error);
      return null;
    }
  }
  // Future<Map<String, dynamic>?> getClassesById(String classId) async {
  //   try {
  //     final response = await _dio.get("/classes/$classId");
  //     // print(response.data["data"]);
  //     return response.data['data'];
  //   } on DioException catch (error) {
  //     print(error);
  //     return null;
  //   }
  // }

 
}