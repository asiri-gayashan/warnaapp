import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/select_options.dart';

// ============================================================
// MODEL
// ============================================================

class StudentProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String districtId;
  final String districtName;
  final String grade; // id matching SelectOptions.newgradesList
  final String school;
  final String description;

  const StudentProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.districtId,
    required this.districtName,
    required this.grade,
    required this.school,
    required this.description,
  });

  StudentProfileModel copyWith({
    String? fullName,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? districtId,
    String? districtName,
    String? grade,
    String? school,
    String? description,
  }) {
    return StudentProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      grade: grade ?? this.grade,
      school: school ?? this.school,
      description: description ?? this.description,
    );
  }
}

// ============================================================
// STATIC DATA
// ============================================================

final List<Map<String, String>> studentProfileDistrictOptions = [
  for (int i = 0; i < SelectOptions.districtsList.length; i++)
    {'id': 'd${i + 1}', 'name': SelectOptions.districtsList[i]},
];

// ============================================================
// CONTROLLER
// ============================================================

class StudentProfileController extends ChangeNotifier {
  bool isLoading = false;
  bool isSaving = false;

  StudentProfileModel? profile;

  List<Map<String, String>> get districts => studentProfileDistrictOptions;
  List<Map<String, String>> get grades =>
      SelectOptions.newgradesList.toList();

  // ── Validation state ──────────────────────────────────────────
  bool _fullNameValid = false;
  bool _phoneValid = false;
  bool _addressLine1Valid = false;
  bool _addressLine2Valid = true;
  bool _gradeValid = false;
  bool _schoolValid = true;
  bool _descriptionValid = true;
  bool _districtValid = false;

  String? fullNameError;
  String? phoneError;
  String? addressLine1Error;
  String? addressLine2Error;
  String? gradeError;
  String? schoolError;
  String? descriptionError;
  String? districtError;

  bool get isFormValid =>
      _fullNameValid &&
      _phoneValid &&
      _addressLine1Valid &&
      _addressLine2Valid &&
      _gradeValid &&
      _schoolValid &&
      _descriptionValid &&
      _districtValid;

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

  void setGrade(String? id) {
    if (id == null || id.isEmpty) {
      _gradeValid = false;
      gradeError = 'Grade is required';
    } else {
      _gradeValid = true;
      gradeError = null;
    }
    notifyListeners();
  }

  void validateSchool(String value) {
    final trimmed = value.trim();
    if (trimmed.length > 100) {
      _schoolValid = false;
      schoolError = 'School name must not exceed 100 characters';
    } else {
      _schoolValid = true;
      schoolError = null;
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

  void _initValidation(StudentProfileModel p) {
    validateFullName(p.fullName);
    validatePhone(p.phone);
    validateAddressLine1(p.addressLine1);
    validateAddressLine2(p.addressLine2);
    setDistrict(p.districtId);
    setGrade(p.grade);
    validateSchool(p.school);
    validateDescription(p.description);
  }

  // ── Fetch profile (dummy) ─────────────────────────────────────
  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    profile = const StudentProfileModel(
      id: 's1',
      fullName: 'Ashan Perera',
      email: 'ashan@example.com',
      phone: '0771234567',
      addressLine1: '123/A Kandy Road, Peliyagoda',
      addressLine2: 'Kiribathgoda',
      districtId: 'd1',
      districtName: 'Colombo',
      grade: '12',
      school: 'Royal College',
      description: 'I am an A/L student passionate about science subjects.',
    );

    _initValidation(profile!);
    isLoading = false;
    notifyListeners();
  }

  // ── Update profile (dummy) ────────────────────────────────────
  Future<bool> updateProfile(StudentProfileModel updated) async {
    isSaving = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    profile = updated;
    isSaving = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
