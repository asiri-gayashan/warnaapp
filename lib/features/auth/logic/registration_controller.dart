import 'package:flutter/material.dart';

enum UserRole {
  instituteAdmin,
  teacher,
  student,
}

class RegistrationController extends ChangeNotifier {
  // Current Step
  int _currentStep = 1;
  int get currentStep => _currentStep;

  // Role Selection
  UserRole? _selectedRole;
  UserRole? get selectedRole => _selectedRole;

  // Form Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  // Validation States
  String? _emailError;
  String? get emailError => _emailError;

  bool _emailValidated = false;
  bool get emailValidated => _emailValidated;

  // Methods
  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void goToNextStep() {
    if (_currentStep < 4) {
      _currentStep++;
      notifyListeners();
    }
  }

  void goToPreviousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setStep(int step) {
    if (step >= 1 && step <= 4) {
      _currentStep = step;
      notifyListeners();
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      _emailError = 'Email is required';
      _emailValidated = false;
      return _emailError;
    }

    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    if (!emailRegex.hasMatch(value)) {
      _emailError = 'Please enter a valid email';
      _emailValidated = false;
      return _emailError;
    }

    _emailError = null;
    _emailValidated = true;
    return null;
  }

  String? validateMobile(String value) {
    if (value.isEmpty) {
      return 'Mobile number is required';
    }

    final mobileRegex = RegExp(r'^[0-9]{10}$');

    if (!mobileRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit number';
    }

    return null;
  }

  void validateEmailRealTime(String value) {
    if (value.isNotEmpty) {
      validateEmail(value);
      notifyListeners();
    }
  }

  bool isStep1Valid() {
    return _selectedRole != null &&
        firstNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        _emailValidated;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }
}