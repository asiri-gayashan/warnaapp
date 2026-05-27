import 'package:flutter/material.dart';
import '../../../core/network/dio_client.dart';
import 'package:dio/dio.dart';

class EnrollStudentsController extends ChangeNotifier {
  final _dio = DioClient.instance;

  /// SEARCH STUDENT BY EMAIL
  Future<Map<String, dynamic>?> searchStudentByEmail(String email) async {
    try {
      final response = await _dio.get("/students/email/$email");
      // print("Search Student Response: ${response.data}");
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
      // print("Get Enrollments Response: ${response.data}");

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

  /// CREATE ENROLL STUDENTS — sends array of {class_id, student_id}
  Future<bool> createEnrollStudents(
      List<Map<String, dynamic>> enrollments) async {
    try {
      final response = await _dio.post(
        "/enrollstudents/",
        data: enrollments,
      );
      // print("Create Enrollments Response: ${response.data}");
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
      final response = await _dio.put(
        "/enrollstudents/$id",
        data: {"status": status},
      );
      // print("Update Enrollment Response: ${response.data}");
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
    print(
        "Selected Student ID: $_selectedStudent, Email: $_selectedStudentEmail");
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