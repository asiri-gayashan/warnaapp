import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginController extends ChangeNotifier {
  // Form Fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // UI State
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isApiCallProcess = false;

  // Validation States
  bool _emailValidated = false;
  bool _passwordValidated = false;

  // Error Messages
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  // Getters
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;
  bool get isApiCallProcess => _isApiCallProcess;
  bool get emailValidated => _emailValidated;
  bool get passwordValidated => _passwordValidated;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get generalError => _generalError;

  bool _isNotValidated = false;
  late SharedPreferences prefs;


  void initSharedPref() async{
    prefs = await SharedPreferences.getInstance();
  }

  // Email Validation
  void validateEmail(String value) {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    if (value.isEmpty) {
      _emailValidated = false;
      _emailError = "Email cannot be empty";
    } else if (!emailRegex.hasMatch(value)) {
      _emailValidated = false;
      _emailError = "Please enter a valid email address";
    } else {
      _emailValidated = true;
      _emailError = null;
    }
    notifyListeners();
  }

  // Password Validation
  void validatePassword(String value) {
    if (value.isEmpty) {
      _passwordValidated = false;
      _passwordError = "Password cannot be empty";
    } else if (value.length < 6) {
      _passwordValidated = false;
      _passwordError = "Password must be at least 8 characters";
    } else {
      _passwordValidated = true;
      _passwordError = null;
    }
    notifyListeners();
  }

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Toggle Remember Me
  void toggleRememberMe(bool? value) {
    if (value != null) {
      _rememberMe = value;
      notifyListeners();
    }
  }

  // Check if form is valid
  bool isFormValid() {
    return _emailValidated && _passwordValidated;
  }

  // Login Method





  Future<Map<String, dynamic>?> loginUser() async {
    if (_emailValidated && _passwordValidated) {

      final user = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(
        Uri.parse("http://10.0.2.2:5001/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        return {
          "role": jsonResponse['data']['role'],
          "token": jsonResponse['token']
        };
      }
    }

    return null;
  }




  //
  // void loginUser() async{
  //   bool status = false;
  //   // String? userTypeRole;
  //   //
  //   // switch (_selectedRole) {
  //   //   case UserRole.instituteAdmin:
  //   //     userTypeRole = "INSTITUTE";
  //   //   case UserRole.teacher:
  //   //     userTypeRole = "TUTOR";
  //   //
  //   //   case UserRole.student:
  //   //     userTypeRole = "STUDENT";
  //   //
  //   //   default:
  //   //     userTypeRole = null;
  //   // }
  //
  //   if(_emailValidated && _passwordValidated){
  //
  //
  //     final user = {
  //       "email": emailController.text,
  //       "password": passwordController.text
  //     };
  //
  //     var response= await http.post(Uri.parse("http://10.0.2.2:5001/api/auth/login"),
  //       headers: {
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode(user),
  //
  //     );
  //
  //     var jsonResponse = jsonDecode(response.body);
  //
  //       // debugPrint("Status Code: ${response.statusCode}");
  //       // debugPrint("Response Body: ${response.body}");
  //     if (jsonResponse['status'] == true) {
  //       // print(jsonResponse['token']);
  //       // print(jsonResponse['data']['role']);
  //       var myToken = jsonResponse['token'];
  //       prefs.setString('token', myToken);
  //       // Navigator.pushReplacementNamed(context, '/student');
  //
  //
  //     }else{
  //       print("Something went wrong");
  //     }
  //
  //     // debugPrint(user.toString());
  //
  //   }
  //
  //
  // }
  //





  // Private Methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    _isApiCallProcess = loading;
    notifyListeners();
  }

  void _clearGeneralError() {
    _generalError = null;
    notifyListeners();
  }

  // Clear form
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    _emailValidated = false;
    _passwordValidated = false;
    _emailError = null;
    _passwordError = null;
    _generalError = null;
    _rememberMe = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}