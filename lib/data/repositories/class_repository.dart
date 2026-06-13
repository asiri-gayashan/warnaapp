import 'package:dio/dio.dart';
import 'package:warna_app/data/models/class_model.dart';
import '../../core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';


class ClassRepository {
  final Dio _dio = DioClient.instance;

   Future<List<dynamic>?> getClasses() async {
     final user = await UserService.getUser();

    try {
      final response = await _dio.get("/classes/institute/${user?["id"]}");
      return response.data['data'];
    } on DioException catch (error) {
      print(error);
      return null;
    }
  }


  Future<List<dynamic>?> getTutorClasses(String tutorId) async {
    try {
      final response = await _dio.get("/classes/tutor/$tutorId");
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