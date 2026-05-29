import 'package:dio/dio.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

class MarkAttendanceController {
  final _dio = DioClient.instance;

  // GET enrolled students by class id
  Future<List<Map<String, dynamic>>?> getEnrollStudentsByClassId(
      String classId) async {
    try {
      final response = await _dio.get("/enrollstudents/$classId");
      final data = response.data['data'] as List;
      return data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // GET attendance by class id and date
  Future<List<Map<String, dynamic>>?> getAttendanceByClassAndDate(
      String classId, String date) async {
    try {
      final response =
          await _dio.get("/attendance/$classId", queryParameters: {"date": date});
      final data = response.data['data'] as List;
      return data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // POST — insert new attendance records (array)
  Future<bool> insertAttendance(List<Map<String, dynamic>> records) async {
    try {
      await _dio.post("/attendance", data: records);
      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // PATCH — update single attendance record status
  Future<bool> updateAttendanceStatus(String id, String status) async {
    try {
      await _dio.patch("/attendance/$id", data: {"status": status});
      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Get logged in user id
  Future<String?> getMarkedUserId() async {
    final user = await UserService.getUser();
    return user?['id']?.toString();
  }
}