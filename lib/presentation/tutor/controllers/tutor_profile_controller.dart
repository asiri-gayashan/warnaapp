import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/data/repositories/metadata_repository.dart';

// ============================================================
// MODEL
// ============================================================

class TutorProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String districtId;
  final String districtName;
  final String subjectId;
  final String subjectName;
  final String experience; // raw integer string, e.g. "8"
  final String description;

  const TutorProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.districtId,
    required this.districtName,
    required this.subjectId,
    required this.subjectName,
    required this.experience,
    required this.description,
  });

  factory TutorProfileModel.fromJson(Map<String, dynamic> j) {
    final users = j['users'] as Map<String, dynamic>? ?? {};
    final district = users['district'] as Map<String, dynamic>? ?? {};
    final subject = j['subject'] as Map<String, dynamic>? ?? {};
    return TutorProfileModel(
      id: j['id'] ?? '',
      fullName: users['full_name'] ?? '',
      email: users['email'] ?? '',
      phone: users['phone'] ?? '',
      addressLine1: users['address_line1'] ?? '',
      addressLine2: users['address_line2'] ?? '',
      districtId: users['district_id'] ?? '',
      districtName: district['name'] ?? '',
      subjectId: j['subject_id'] ?? '',
      subjectName: subject['name'] ?? '',
      experience: (j['experience'] ?? 0).toString(),
      description: users['description'] ?? '',
    );
  }

  TutorProfileModel copyWith({
    String? fullName,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? districtId,
    String? districtName,
    String? subjectId,
    String? subjectName,
    String? experience,
    String? description,
  }) {
    return TutorProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      experience: experience ?? this.experience,
      description: description ?? this.description,
    );
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class TutorProfileController extends ChangeNotifier {
  final _dio = DioClient.instance;
  final _metadata = MetadataRepository();

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  TutorProfileModel? profile;

  List<Map<String, String>> _districts = [];
  List<Map<String, String>> _subjects = [];

  List<Map<String, String>> get districts => _districts;
  List<Map<String, String>> get subjects => _subjects;

  // ── Validation state ──────────────────────────────────────────
  bool _fullNameValid = false;
  bool _phoneValid = false;
  bool _addressLine1Valid = false;
  bool _addressLine2Valid = true; // optional
  bool _experienceValid = false;
  bool _descriptionValid = true; // optional
  bool _districtValid = false;
  bool _subjectValid = false;

  String? fullNameError;
  String? phoneError;
  String? addressLine1Error;
  String? addressLine2Error;
  String? experienceError;
  String? descriptionError;
  String? districtError;
  String? subjectError;

  bool get isFormValid =>
      _fullNameValid &&
      _phoneValid &&
      _addressLine1Valid &&
      _addressLine2Valid &&
      _experienceValid &&
      _descriptionValid &&
      _districtValid &&
      _subjectValid;

  // ── Validators ────────────────────────────────────────────────

  void validateFullName(String value) {
    final name = value.trim();
    final nameRegex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (name.isEmpty) {
      _fullNameValid = false;
      fullNameError = 'Full name is required';
    } else if (name.length < 10) {
      _fullNameValid = false;
      fullNameError = 'Full name must be at least 10 characters';
    } else if (name.length > 30) {
      _fullNameValid = false;
      fullNameError = 'Full name must not exceed 30 characters';
    } else if (!nameRegex.hasMatch(name)) {
      _fullNameValid = false;
      fullNameError = 'Only letters and single spaces allowed';
    } else {
      _fullNameValid = true;
      fullNameError = null;
    }
    notifyListeners();
  }

  void validatePhone(String value) {
    final phone = value.trim();
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (phone.isEmpty) {
      _phoneValid = false;
      phoneError = 'Mobile number is required';
    } else if (phone.length != 10) {
      _phoneValid = false;
      phoneError = 'Mobile number must be exactly 10 digits';
    } else if (!phone.startsWith('07')) {
      _phoneValid = false;
      phoneError = 'Mobile number must start with 07';
    } else if (!phoneRegex.hasMatch(phone)) {
      _phoneValid = false;
      phoneError = 'Mobile number must contain only digits';
    } else {
      _phoneValid = true;
      phoneError = null;
    }
    notifyListeners();
  }

  void validateAddressLine1(String value) {
    final address = value.trim();
    final addressRegex = RegExp(r'^(?=.*[a-zA-Z0-9])[a-zA-Z0-9\s,.\-\/]+$');
    if (address.isEmpty) {
      _addressLine1Valid = false;
      addressLine1Error = 'Address is required';
    } else if (!addressRegex.hasMatch(address)) {
      _addressLine1Valid = false;
      addressLine1Error = 'Only letters, numbers, space [ , . / - ] allowed';
    } else if (address.length < 10) {
      _addressLine1Valid = false;
      addressLine1Error = 'Address must be at least 10 characters';
    } else if (address.length > 100) {
      _addressLine1Valid = false;
      addressLine1Error = 'Address must not exceed 100 characters';
    } else {
      _addressLine1Valid = true;
      addressLine1Error = null;
    }
    notifyListeners();
  }

  void validateAddressLine2(String value) {
    final address = value.trim();
    final addressRegex = RegExp(r'^(?=.*[a-zA-Z0-9])[a-zA-Z0-9\s,.\-\/]+$');
    if (address.isEmpty) {
      _addressLine2Valid = true;
      addressLine2Error = null;
    } else if (!addressRegex.hasMatch(address)) {
      _addressLine2Valid = false;
      addressLine2Error = 'Only letters, numbers, space [ , . / - ] allowed';
    } else if (address.length > 100) {
      _addressLine2Valid = false;
      addressLine2Error = 'Address must not exceed 100 characters';
    } else {
      _addressLine2Valid = true;
      addressLine2Error = null;
    }
    notifyListeners();
  }

  void validateExperience(String value) {
    final trimmed = value.trim();
    final numValue = int.tryParse(trimmed);
    if (trimmed.isEmpty) {
      _experienceValid = false;
      experienceError = 'Years of experience is required';
    } else if (numValue == null) {
      _experienceValid = false;
      experienceError = 'Please enter a valid number';
    } else if (numValue < 0 || numValue > 50) {
      _experienceValid = false;
      experienceError = 'Experience must be between 0 and 50';
    } else {
      _experienceValid = true;
      experienceError = null;
    }
    notifyListeners();
  }

  void validateDescription(String value) {
    final trimmed = value.trim();
    if (trimmed.length > 200) {
      _descriptionValid = false;
      descriptionError = 'Description must not exceed 200 characters';
    } else {
      _descriptionValid = true;
      descriptionError = null;
    }
    notifyListeners();
  }

  void setDistrict(String? id) {
    if (id == null || id.isEmpty) {
      _districtValid = false;
      districtError = 'District is required';
    } else {
      _districtValid = true;
      districtError = null;
    }
    notifyListeners();
  }

  void setSubject(String? id) {
    if (id == null || id.isEmpty) {
      _subjectValid = false;
      subjectError = 'Subject is required';
    } else {
      _subjectValid = true;
      subjectError = null;
    }
    notifyListeners();
  }

  /// Pre-validate loaded profile data so the form starts as valid.
  void _initValidation(TutorProfileModel p) {
    validateFullName(p.fullName);
    validatePhone(p.phone);
    validateAddressLine1(p.addressLine1);
    validateAddressLine2(p.addressLine2);
    validateExperience(p.experience);
    validateDescription(p.description);
    setDistrict(p.districtId);
    setSubject(p.subjectId);
  }

  // ── Fetch profile ─────────────────────────────────────────────
  Future<bool> fetchProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final email = user?['email'];

      final results = await Future.wait([
        _dio.get('/teachers/email/$email'),
        _metadata.getDistricts(),
        _metadata.getSubjects(),
      ]);

      final teacherRes = results[0] as dynamic;
      final districtsRaw = results[1] as List<dynamic>?;
      final subjectsRaw = results[2] as List<dynamic>?;

      if (districtsRaw != null) {
        _districts = districtsRaw
            .map((d) => {'id': d['id'].toString(), 'name': d['name'].toString()})
            .toList();
      }

      if (subjectsRaw != null) {
        _subjects = subjectsRaw
            .map((s) => {'id': s['id'].toString(), 'name': s['name'].toString()})
            .toList();
      }

      final data = teacherRes.data['data'];
      if (data != null) {
        profile = TutorProfileModel.fromJson(data as Map<String, dynamic>);
        _initValidation(profile!);
        isLoading = false;
        notifyListeners();
        return true;
      }

      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Error fetching tutor profile: $e');
      errorMessage = 'Failed to load profile';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Update profile ────────────────────────────────────────────
  Future<bool> updateProfile(TutorProfileModel updated) async {
    isSaving = true;
    notifyListeners();

    try {
      await _dio.put(
        '/teachers/${updated.id}',
        data: {
          'full_name': updated.fullName,
          'phone': updated.phone,
          'address_line1': updated.addressLine1,
          'address_line2': updated.addressLine2,
          'description': updated.description,
          'district_id': updated.districtId,
          'subject_id': updated.subjectId,
          'experience': int.tryParse(updated.experience) ?? 0,
        },
      );

      profile = updated;
      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating tutor profile: $e');
      isSaving = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
