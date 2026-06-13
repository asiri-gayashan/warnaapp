import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class TutorEnrollStudentsController extends ChangeNotifier {
  final _dio = DioClient.instance;

  /// SEARCH STUDENT BY EMAIL
  Future<Map<String, dynamic>?> searchStudentByEmail(String email) async {
    try {
      final response = await _dio.get("/students/email/$email");
      return response.data;
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// GET ENROLL STUDENTS BY CLASS ID
  Future<List<Map<String, dynamic>>?> getEnrollStudentsByClassId(
      String classId) async {
    try {
      final response = await _dio.get("/enrollstudents/$classId");
      final data = response.data['data'] as List;
      return data.map<Map<String, dynamic>>((e) => e).toList();
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// CREATE ENROLL STUDENTS — sends array of {class_id, student_id, status}
  Future<bool> createEnrollStudents(
      List<Map<String, dynamic>> enrollments) async {
    try {
      await _dio.post(
        "/enrollstudents/",
        data: enrollments,
      );
      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// UPDATE ENROLLMENT STATUS — ACTIVE or INACTIVE
  Future<bool> updateEnrollmentStatus(String id, String status) async {
    try {
      await _dio.put(
        "/enrollstudents/$id",
        data: {"status": status},
      );
      return true;
    } on DioException catch (e) {
      print(e.response?.data);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// SELECTED STUDENT
  String? _selectedStudent;
  String? get selectedStudent => _selectedStudent;

  /// SELECTED STUDENT EMAIL
  String? _selectedStudentEmail;
  String? get selectedStudentEmail => _selectedStudentEmail;

  /// VALIDATION
  bool _studentValidated = false;
  bool get studentValidated => _studentValidated;

  /// ERROR
  String? _studentError;
  String? get studentError => _studentError;

  /// SET STUDENT
  void setStudentWithName(String? id, String? email) {
    _selectedStudent = id;
    _selectedStudentEmail = email;

    if (id == null || id.isEmpty) {
      _studentValidated = false;
      _studentError = "Please select a student";
    } else {
      _studentValidated = true;
      _studentError = null;
    }

    notifyListeners();
  }

  /// CLEAR SELECTED STUDENT
  void clearSelectedStudent() {
    _selectedStudent = null;
    _selectedStudentEmail = null;
    _studentValidated = false;
    _studentError = null;
    notifyListeners();
  }
}
