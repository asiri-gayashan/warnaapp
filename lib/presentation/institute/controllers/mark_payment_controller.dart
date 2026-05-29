import 'package:dio/dio.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

class MarkPaymentController {
  final _dio = DioClient.instance;

  // GET enrolled students by class id
  Future<List<Map<String, dynamic>>?> getEnrollStudentsByClassId(
      String classId) async {
    try {
      final response = await _dio.get("/enrollstudents/$classId");
      final data = response.data['data'] as List;
      return data
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // GET payments by class id, month, year
  Future<List<Map<String, dynamic>>?> getPaymentsByClassAndMonth(
      String classId, int month, int year) async {
    try {
      final response = await _dio.get(
        "/student-payments/$classId",
        queryParameters: {"month": month, "year": year},
      );
      final data = response.data['data'] as List;
      return data
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // POST — insert new payment records (array)
  Future<bool> insertPayments(List<Map<String, dynamic>> payments) async {
    try {
      await _dio.post("/student-payments", data: payments);
      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // PATCH — update single payment status
  Future<bool> updatePaymentStatus(String id, String status) async {
    try {
      await _dio.patch("/student-payments/$id", data: {"status": status});
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