class RegistrationStrings {
  // Progress Steps
  static const List<String> progressSteps = [
    'Account',
    'Security',
    'Details',
    'Verify',
    'Done'
  ];

  // Step 1 - Basic Information
  static const String step1Title = 'Create Your Account';
  static const String step1Subtitle = 'Start your journey with us';

  static const String selectRole = 'Select Your Role';
  static const String roleAdmin = 'Institute Admin';
  static const String roleAdminDesc = 'Manage institute, staff & students';
  static const String roleTeacher = 'Teacher';
  static const String roleTeacherDesc = 'Create courses & teach students';
  static const String roleStudent = 'Student';
  static const String roleStudentDesc = 'Learn from courses & assignments';

  static const String fullName = 'Full Name';
  static const String fullNameHint = 'Enter your full name';
  static const String emailAddress = 'Email Address';
  static const String emailHint = 'name@example.com';
  static const String mobileNumber = 'Mobile Number';
  static const String mobileHint = 'Enter your phone number';

  // Step 2 - Account Security
  static const String step2Title = 'Secure Your Account';
  static const String step2Subtitle = 'Create a strong password to protect your account';

  static const String password = 'Password';
  static const String passwordHint = 'Create a password';
  static const String confirmPassword = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';

  static const String passwordRules = 'Password must contain:';
  static const String ruleMinLength = '✔ 8+ characters';
  static const String ruleNumber = '✔ Number';
  static const String ruleSpecialChar = '✔ Special character';

  // Step 3 - Role Specific
  static const String step3TitleAdmin = 'Institute Details';
  static const String step3TitleTeacher = 'Teacher Details';
  static const String step3TitleStudent = 'Student Details';

  // Admin Fields
  static const String instituteName = 'Institute Name';
  static const String instituteNameHint = 'Enter institute name';
  static const String instituteType = 'Institute Type';
  static const String instituteTypeHint = 'Select type';
  static const String address = 'Address';
  static const String addressHint = 'Enter address';
  static const String city = 'City';
  static const String cityHint = 'Enter city';
  static const String numberOfTeachers = 'Number of Teachers (optional)';
  static const String teachersHint = 'Enter number';

  // Teacher Fields
  static const String subjectsTaught = 'Subject(s) taught';
  static const String subjectsHint = 'e.g., Math, Science';
  static const String teachingType = 'Teaching Type';
  static const String experience = 'Years of Experience';
  static const String experienceHint = 'Enter years';
  static const String qualification = 'Qualification';
  static const String qualificationHint = 'e.g., M.Ed, B.Sc';

  // Student Fields
  static const String gradeLevel = 'Grade / Level';
  static const String gradeHint = 'e.g., Grade 10, College';
  static const String school = 'School (optional)';
  static const String schoolHint = 'Enter school name';
  static const String subjectsEnrolled = 'Subjects Enrolled (optional)';
  static const String enrolledHint = 'e.g., Math, Physics';

  // Step 4 - Email Verification
  static const String step4Title = 'Verify Your Email';
  static const String step4Subtitle = 'We sent a verification code to your email';
  static const String otpInstruction = 'Enter the 6-digit code sent to';
  static const String verifyButton = 'Verify';
  static const String resendCode = 'Resend Code';
  static const String resendIn = 'Resend in';
  static const String seconds = 'seconds';
  static const String codeVerified = 'Email verified successfully!';

  // Step 5 - Success Screen
  static const String step5TitleAdmin = '🎉 Your Institute Account is Ready!';
  static const String step5MessageAdmin = 'Your institute account is ready. Create your first class.';
  static const String step5TitleTeacher = '🎉 Your Teacher Account is Active!';
  static const String step5MessageTeacher = 'Your teacher account is active. Add your classes.';
  static const String step5TitleStudent = '🎉 Your Account is Ready!';
  static const String step5MessageStudent = 'Your account is ready. Join your classes.';
  static const String goToDashboard = 'Go to Dashboard';

  // Common
  static const String next = 'Next';
  static const String back = 'Back';
  static const String submit = 'Submit';
  static const String requiredField = 'This field is required';
  static const String optional = '(optional)';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordsDontMatch = 'Passwords do not match';
  static const String mobileRequired = 'Mobile number is required';
  static const String invalidMobile = 'Please enter a valid 10-digit number';
  static const String otpRequired = 'Please enter the verification code';
  static const String invalidOtp = 'Please enter a valid 6-digit code';
}