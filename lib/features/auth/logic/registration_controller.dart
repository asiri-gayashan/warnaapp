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

  // -------------------------------------------------------------------Step 1: Basic Information

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  bool _emailValidated = false;
  bool get emailValidated => _emailValidated;
  String? _emailError;
  String? get emailError => _emailError;
                     //  Email

  bool _fullNameValidated  = false;
  bool get fullNameValidated {
    return _fullNameValidated;
  }
  String? _fullNameError;
  String? get fullNameError => _fullNameError;                   /// Full Name

  bool _mobileValidated  = false;
  bool get mobileValidated {
    return _mobileValidated;
  }
  String? _mobileError;
  String? get mobileError => _mobileError;
              /// Mobile number


  //----------------------------------------------------------------------Step 2


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


  //----------------------------------------------------------------------Step 3


  final TextEditingController addressController = TextEditingController();
  final TextEditingController instituteNameController = TextEditingController();
  String? _instituteType;
  String? get instituteType => _instituteType;
  final TextEditingController cityController = TextEditingController();
  final TextEditingController teachersCountController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();
  String? _teachingType;
  String? get teachingType => _teachingType;
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();


// Address Line 1 validation state
  bool _addressOneValidated = false;
  bool get addressOneValidated => _addressOneValidated;
  String? _addressOneError;
  String? get addressOneError => _addressOneError;



  bool _addressTwoValidated = false;
  bool get addressTwoValidated => _addressTwoValidated;
  String? _addressTwoError;
  String? get addressTwoError => _addressTwoError;

  bool _provinceValidated = false;
  bool get provinceValidated => _provinceValidated;
  String? _provinceError;
  String? get provinceError => _provinceError;
  String? _selectedProvince;
  String? get selectedProvince => _selectedProvince;                       //Province

  String? _selectedTeacherCount;
  String? get selectedTeacherCount => _selectedTeacherCount;
  bool _teacherCountValidated = false;
  bool get teacherCountValidated => _teacherCountValidated;
  String? _teacherCountError;
  String? get teacherCountError => _teacherCountError;                  //Teacher

  String? _selectedMajorSubject;
  String? get selectedMajorSubject => _selectedMajorSubject;
  bool _majorSubjectValidated = false;
  bool get majorSubjectValidated => _majorSubjectValidated;
  String? _majorSubjectError;
  String? get majorSubjectError => _majorSubjectError;                     // Subject

  String? _selectedExperience;
  String? get selectedExperience => _selectedExperience;
  bool _experienceValidated = false;
  bool get experienceValidated => _experienceValidated;
  String? _experienceError;
  String? get experienceError => _experienceError;                   //Experience


  bool _instituteNameValidated = false;
  bool get instituteNameValidated => _instituteNameValidated;
  String? _instituteNameError;
  String? get instituteNameError => _instituteNameError;                    // Institute Name


  bool _schoolNameValidated = true;
  bool get schoolNameValidated => _schoolNameValidated;
  String? _schoolNameError;
  String? get schoolNameError => _schoolNameError;                            // School Name

  String? _selectedStudentCount;
  String? get selectedStudentCount => _selectedStudentCount;
  bool _studentCountValidated = false;
  bool get studentCountValidated => _studentCountValidated;
  String? _studentCountError;
  String? get studentCountError => _studentCountError;                           //Student Count

  String? _selectedGrade;
  String? get selectedGrade => _selectedGrade;
  bool _gradeValidated = false;
  bool get gradeValidated => _gradeValidated;
  String? _gradeError;
  String? get gradeError => _gradeError;                                      //Grade




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
      // print(value);

      _mobileValidated = true;
      _mobileError = null;

    }

    notifyListeners();
  }


  // Email Validation
  void validateEmail(String value) {

    // String  _emailValue;
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

  // Teaching Type
  void setTeachingType(String? type) {
    _teachingType = type;
    notifyListeners();
  }

  // Teacher validation
  void validateAddressOne(String value) {
    final address = value.trim();

    // Allows letters, numbers, space, comma, dot, slash, hyphen
    final RegExp addressRegex = RegExp(
        r'^(?=.*[a-zA-Z0-9])[a-zA-Z0-9\s,.\-\/]+$'
    );

    if (address.isEmpty) {
      _addressOneValidated = false;
      _addressOneError = "Address is required";
    }else if (!addressRegex.hasMatch(address)) {
      _addressOneValidated = false;
      _addressOneError =
      "Only letters, numbers, space [ , . / - ] allowed";
    }
    else if (address.length < 10) {
      _addressOneValidated = false;
      _addressOneError = "Address must be at least 10 characters";
    }
    else if (address.length > 100) {
      _addressOneValidated = false;
      _addressOneError = "Address must not exceed 100 characters";
    }

    else {
      _addressOneValidated = true;
      _addressOneError = null;
    }

    notifyListeners();
  }

  //
  // void validateAddressTwo(String value) {
  //   final address = value.trim();
  //
  //   // Allows letters, numbers, space, comma, dot, slash, hyphen
  //   final RegExp addressRegex = RegExp(
  //       r'^(?=.*[a-zA-Z0-9])[a-zA-Z0-9\s,.\-\/]+$'
  //   );
  //
  //
  //   if ((address.length > 10 ) || !addressRegex.hasMatch(address)) {
  //     _addressTwoValidated = false;
  //     _addressTwoError = "Character limit exceed";
  //   }else{
  //     _addressTwoValidated = true;
  //     _addressTwoError = null;
  //
  //   }
  //
  //
  //   notifyListeners();
  // }



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


  //----------------------------------------------------------Step 3 Teacher validation

//setProvince

  void setProvince(String value) {
    _selectedProvince = value;

    if (_selectedProvince == null || _selectedProvince!.isEmpty) {
      _provinceValidated = false;
      _provinceError = "Province is required";
    } else {
      _provinceValidated = true;
      _provinceError = null;
    }

    notifyListeners();
  }

//Major Subject Validation


  void setMajorSubject(String value) {
    _selectedMajorSubject = value;

    if (_selectedMajorSubject == null || _selectedMajorSubject!.isEmpty) {
      _majorSubjectValidated = false;
      _majorSubjectError = "Major subject is required";
    } else {
      _majorSubjectValidated = true;
      _majorSubjectError = null;
    }

    notifyListeners();
  }


 //Years of Experience Validation

  void setExperience(String value) {
    _selectedExperience = value;

    if (_selectedExperience == null || _selectedExperience!.isEmpty) {
      _experienceValidated = false;
      _experienceError = "Years of experience is required";
    } else {
      _experienceValidated = true;
      _experienceError = null;
    }

    notifyListeners();
  }




//----------------------------------------------------------------------------Student Valiadation


  void validateSchoolName(String value) {
    final school = value.trim();
    // _schoolName = school;

    // Regex: letters + single spaces only
    final RegExp schoolRegex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');

    // Optional → allow empty
    if (school.isEmpty) {
      _schoolNameValidated = true;
      _schoolNameError = null;
    }
    else if (!schoolRegex.hasMatch(school)) {
      _schoolNameValidated = false;
      _schoolNameError = "School name cannot contain numbers or special characters";
    }
    else {
      _schoolNameValidated = true;
      _schoolNameError = null;
    }

    notifyListeners();
  }


  //----------------------------------------------------------------------------------------Grades Selection Validation

  void setGrade(String value) {
    _selectedGrade = value;
    if (_selectedGrade == null || _selectedGrade!.isEmpty) {
      _gradeValidated = false;
      _gradeError = "Grade is required";
    } else {
      _gradeValidated = true;
      _gradeError = null;
    }
    notifyListeners();
  }

//------------------------------------------------------------------------ institute validation



  void validateInstituteName(String value) {
    final institute = value.trim();

    //  letters, spaces, dot, brack
    final RegExp instituteRegex =
    RegExp(r'^[a-zA-Z(). ]+$');

    if (institute.isEmpty) {
      _instituteNameValidated = false;
      _instituteNameError = "Institute name is required";
    }
    else if (institute.length < 5) {
      _instituteNameValidated = false;
      _instituteNameError =
      "Institute name must be at least 5 characters";
    }
    else if (institute.length > 50) {
      _instituteNameValidated = false;
      _instituteNameError =
      "Institute name must not exceed 50 characters";
    }
    else if (!instituteRegex.hasMatch(institute)) {
      _instituteNameValidated = false;
      _instituteNameError =
      "Only letters, spaces, '.' and brackets () are allowed";
    }
    else {
      _instituteNameValidated = true;
      _instituteNameError = null;
    }

    notifyListeners();
  }


  void setStudentCount(String value) {
    _selectedStudentCount = value;

    if (_selectedStudentCount == null ||
        _selectedStudentCount!.isEmpty) {
      _studentCountValidated = false;
      _studentCountError = "Student count is required";
    } else {
      _studentCountValidated = true;
      _studentCountError = null;
    }

    notifyListeners();
  }


  void setTeacherCount(String value) {
    _selectedTeacherCount = value;

    if (_selectedTeacherCount == null ||
        _selectedTeacherCount!.isEmpty) {
      _teacherCountValidated = false;
      _teacherCountError = "Teacher count is required";
    } else {
      _teacherCountValidated = true;
      _teacherCountError = null;
    }

    notifyListeners();
  }


  bool isStep3Valid() {
    switch (_selectedRole) {
      case UserRole.instituteAdmin:
        return _instituteNameValidated && _studentCountValidated
        && _teacherCountValidated && _provinceValidated &&
            _addressOneValidated;

      case UserRole.teacher:
        return _addressOneValidated &&
            // _addressTwoValidated &&
            _provinceValidated &&
            _experienceValidated  &&
            _majorSubjectValidated;

      case UserRole.student:
        return _schoolNameValidated &&
            _gradeValidated  &&
            _provinceValidated &&
            _addressOneValidated;

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