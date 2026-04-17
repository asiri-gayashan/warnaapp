import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:warna_app/core/utils/token_service.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/router/router_names.dart';
import '../../../../config/config.dart';
import 'package:dio/dio.dart';

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

  // Email Validation
  void validateEmail(String value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
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

  // Logout Method

  Future<void> logoutUser(BuildContext context) async {
    await TokenService.clearTokens(); // clears secure storage
    await UserService.clearUser(); // clears shared preferences

    // ignore: use_build_context_synchronously
    GoRouter.of(context).goNamed(RouterNames.loginScreen);
  }

  // Login Method
  Future<Map<String, dynamic>?> loginUser() async {
    if (!_emailValidated || !_passwordValidated) {
      return {"success": false, "message": "Invalid email or password!"};
    }

    final user = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      final response = await Dio().post(
        "http://10.0.2.2:5001/api/auth/login",
        data: user,
      );

      // print("SUCCESS: ${response.data}");

      final loggedInUser = response.data['user'];
      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        await TokenService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      if (loggedInUser != null) {
        await UserService.saveUser(loggedInUser);
      }

      return {"success": true, "message": "Logged in successfully!"};
    } on DioException catch (e) {
      print("ERROR: ${e.response?.data}");

      return {
        "success": false,
        "message": e.response?.data["message"] ?? "Login failed",
      };
    }
  }

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
