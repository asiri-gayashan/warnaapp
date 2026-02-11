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

  // Step 1: Basic Information
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  bool _emailValidated = false;
  bool get emailValidated => _emailValidated;

  // Step 2: Account Security
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  // Password Validation
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;

  bool get hasMinLength => _hasMinLength;
  bool get hasNumber => _hasNumber;
  bool get hasSpecialChar => _hasSpecialChar;
  bool get passwordsMatch => _passwordsMatch;

  // Step 3: Role Specific Details
  // Admin Fields
  final TextEditingController instituteNameController = TextEditingController();
  String? _instituteType;
  String? get instituteType => _instituteType;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController teachersCountController = TextEditingController();

  // Teacher Fields
  final TextEditingController subjectsController = TextEditingController();
  String? _teachingType;
  String? get teachingType => _teachingType;
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();

  // Student Fields
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController enrolledSubjectsController = TextEditingController();

  // Step 4: OTP Verification
  String _otp = '';
  bool _isOtpVerified = false;
  bool _isResendEnabled = false;
  int _resendTimer = 30;

  String get otp => _otp;
  bool get isOtpVerified => _isOtpVerified;
  bool get isResendEnabled => _isResendEnabled;
  int get resendTimer => _resendTimer;

  // Methods
  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void goToNextStep() {
    if (_currentStep < 5) {
      _currentStep++;
      notifyListeners(); // ← ADD THIS LINE
    }
  }

  void goToPreviousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setStep(int step) {
    if (step >= 1 && step <= 5) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Email Validation
  void validateEmail(String value) {
    if (value.isEmpty) {
      _emailValidated = false;
    } else {
      final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
      );
      _emailValidated = emailRegex.hasMatch(value);
    }
    notifyListeners();
  }

  // Password Validation
  void validatePassword(String password) {
    _hasMinLength = password.length >= 8;
    _hasNumber = RegExp(r'[0-9]').hasMatch(password);
    _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    _passwordsMatch = password == confirmPasswordController.text;
    notifyListeners();
  }

  void validateConfirmPassword(String confirmPassword) {
    _passwordsMatch = passwordController.text == confirmPassword;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // Institute Type
  void setInstituteType(String? type) {
    _instituteType = type;
    notifyListeners();
  }
  // void setProvince(String? type) {
  //   _province = type;
  //   notifyListeners();
  // }

  // Teaching Type
  void setTeachingType(String? type) {
    _teachingType = type;
    notifyListeners();
  }

  // OTP Methods
  void setOtp(String otp) {
    _otp = otp;
    notifyListeners();
  }

  void verifyOtp() {
    _isOtpVerified = true;
    notifyListeners();
  }

  void startResendTimer() {
    _isResendEnabled = false;
    _resendTimer = 30;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      if (_resendTimer > 0) {
        _resendTimer--;
        startResendTimer();
      } else {
        _isResendEnabled = true;
        notifyListeners();
      }
    });
  }

  // Validation Methods
  bool isStep1Valid() {
    return _selectedRole != null &&
        fullNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        _emailValidated;
  }

  bool isStep2Valid() {
    return _hasMinLength &&
        _hasNumber &&
        _hasSpecialChar &&
        _passwordsMatch &&
        passwordController.text.isNotEmpty;
  }

  bool isStep3Valid() {
    switch (_selectedRole) {
      case UserRole.instituteAdmin:
        return instituteNameController.text.isNotEmpty &&
            _instituteType != null &&
            addressController.text.isNotEmpty &&
            cityController.text.isNotEmpty;

      case UserRole.teacher:
        return subjectsController.text.isNotEmpty &&
            _teachingType != null &&
            experienceController.text.isNotEmpty &&
            qualificationController.text.isNotEmpty;

      case UserRole.student:
        return gradeController.text.isNotEmpty;

      default:
        return false;
    }
  }

  bool isStep4Valid() {
    return _otp.length == 6 && _isOtpVerified;
  }

  // Reset Methods
  void clearPasswordFields() {
    passwordController.clear();
    confirmPasswordController.clear();
    _hasMinLength = false;
    _hasNumber = false;
    _hasSpecialChar = false;
    _passwordsMatch = false;
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    instituteNameController.dispose();
    teachersCountController.dispose();
    addressController.dispose();
    cityController.dispose();
    subjectsController.dispose();
    experienceController.dispose();
    qualificationController.dispose();
    gradeController.dispose();
    schoolController.dispose();
    enrolledSubjectsController.dispose();
    super.dispose();
  }
}