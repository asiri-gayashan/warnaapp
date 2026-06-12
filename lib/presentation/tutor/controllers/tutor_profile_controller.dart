import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/select_options.dart';

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
  final String experienceId;
  final String experienceName;
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
    required this.experienceId,
    required this.experienceName,
    required this.description,
  });

  TutorProfileModel copyWith({
    String? fullName,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? districtId,
    String? districtName,
    String? subjectId,
    String? subjectName,
    String? experienceId,
    String? experienceName,
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
      experienceId: experienceId ?? this.experienceId,
      experienceName: experienceName ?? this.experienceName,
      description: description ?? this.description,
    );
  }
}

// ============================================================
// DROPDOWN OPTIONS (derived from shared SelectOptions)
// ============================================================

List<Map<String, String>> _toIdNameList(List<String> values) {
  return List.generate(
    values.length,
    (i) => {"id": "${i + 1}", "name": values[i]},
  );
}

final List<Map<String, String>> tutorProfileDistricts = _toIdNameList(
  SelectOptions.districtsList,
);

final List<Map<String, String>> tutorProfileSubjects = _toIdNameList(
  SelectOptions.subjects,
);

final List<Map<String, String>> tutorProfileExperienceOptions = _toIdNameList(
  SelectOptions.yearsOfExperience,
);

// ============================================================
// CONTROLLER
// ============================================================

class TutorProfileController extends ChangeNotifier {
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  TutorProfileModel? profile;

  // ── Fetch profile (dummy data) ────────────────────────────────
  Future<bool> fetchProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    profile = const TutorProfileModel(
      id: 'tutor-1',
      fullName: 'Nuwan Perera',
      email: 'nuwan.perera@gmail.com',
      phone: '+94 77 123 4567',
      addressLine1: 'No. 25, Lake Road',
      addressLine2: 'Nugegoda',
      districtId: '1',
      districtName: 'Colombo',
      subjectId: '4',
      subjectName: 'Mathematics',
      experienceId: '4',
      experienceName: '6-10 Years',
      description:
          'Experienced tutor specialising in A/L Combined Mathematics and Physics, with over 8 years of teaching experience helping students achieve top results.',
    );

    isLoading = false;
    notifyListeners();
    return true;
  }

  // ── Update profile (dummy save) ───────────────────────────────
  Future<bool> updateProfile(TutorProfileModel updated) async {
    isSaving = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

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
