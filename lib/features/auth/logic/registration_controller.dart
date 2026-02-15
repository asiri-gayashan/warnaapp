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
  String? _emailError;
  String? get emailError => _emailError;



  bool _fullNameValidated  = false;
  bool get fullNameValidated {
    return _fullNameValidated;
  }
  String? _fullNameError;
  String? get fullNameError => _fullNameError;



  bool _mobileValidated  = false;
  bool get mobileValidated {
    return _mobileValidated;
  }
  String? _mobileError;
  String? get mobileError => _mobileError;


// Address Line 1 validation state
  bool _addressOneValidated = false;
  bool get addressOneValidated => _addressOneValidated;

  String? _addressOneError;
  String? get addressOneError => _addressOneError;






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



  //Validate Full name

  void validateFullName(String value) {
    final name = value.trim();

    final RegExp nameRegex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');

    if (name.isEmpty) {
      _fullNameValidated = false;
      _fullNameError = "Full name is required";
    }
    else if (name.length < 10) {
      _fullNameValidated = false;
      _fullNameError = "Full name must be at least 10 characters";
    }
    else if (name.length > 30) {
      _fullNameValidated = false;
      _fullNameError = "Full name must not exceed 30 characters";
    }
    else if (!nameRegex.hasMatch(name)) {
      _fullNameValidated = false;
      _fullNameError = "Only letters and single spaces allowed";
    }
    else {
      _fullNameValidated = true;
      _fullNameError = null;
    }

    notifyListeners();
  }


// Validate mobile number
  void validateMobile(String value) {
    final phone = value.trim();

    final RegExp phoneRegex = RegExp(r'^[0-9]+$');

    if (phone.isEmpty) {
      _mobileValidated = false;
      _mobileError = "Mobile number is required";
    }
    else if (phone.length != 10) {
      _mobileValidated = false;
      _mobileError = "Mobile number must be exactly 10 digits";
    }
    else if (!phone.startsWith("07")) {
      _mobileValidated = false;
      _mobileError = "Mobile number must start with 07";
    }
    else if (!phoneRegex.hasMatch(phone)) {
      _mobileValidated = false;
      _mobileError = "Mobile number must contain only digits";
    }
    else {
      _mobileValidated = true;
      _mobileError = null;
    }

    notifyListeners();
  }


  // Email Validation
  void validateEmail(String value) {

    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    if (value.isEmpty) {
      _emailValidated = false;
      _emailError = "Email cannot be empty";
    } else if (!emailRegex.hasMatch(value)){
      _emailValidated = false;
      _emailError = "Incorrect email format";
    }else{
      _emailValidated = true;
      _emailError = null;

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


  // Teacher validation
  void validateAddressOne(String value) {
    final address = value.trim();

    // Allows letters, numbers, space, comma, dot, slash, hyphen
    final RegExp addressRegex =
    RegExp(r'^[a-zA-Z0-9\s,.\-\/]+$');

    if (address.isEmpty) {
      _addressOneValidated = false;
      _addressOneError = "Address is required";
    }
    else if (address.length < 5) {
      _addressOneValidated = false;
      _addressOneError = "Address must be at least 5 characters";
    }
    else if (address.length > 100) {
      _addressOneValidated = false;
      _addressOneError = "Address must not exceed 100 characters";
    }
    else if (!addressRegex.hasMatch(address)) {
      _addressOneValidated = false;
      _addressOneError =
      "Only letters, numbers, space [, . / -] allowed";
    }
    else {
      _addressOneValidated = true;
      _addressOneError = null;
    }

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
        // fullNameController.text.isNotEmpty &&
        // isFullNameValid()
        _fullNameValidated && _mobileValidated &&
        emailController.text.isNotEmpty &&
        // mobileController.text.isNotEmpty &&
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