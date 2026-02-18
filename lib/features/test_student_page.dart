import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:warna_app/features/auth/ui/screens/login/login_screen.dart';
// import './auth/ui/screens/login/login_screen.dart';

class TestStudentPage extends StatefulWidget {
  final String token;

  const TestStudentPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<TestStudentPage> createState() => _TestStudentPageState();
}

class _TestStudentPageState extends State<TestStudentPage> {

  late Map<String, dynamic> decodedToken;
  late String email;
  late String userID;
  late String role;

  @override
  void initState() {
    super.initState();
    _validateToken();
  }

  void _validateToken() {
    if (widget.token.isEmpty || JwtDecoder.isExpired(widget.token)) {
      _logout();
      return;
    }

    decodedToken = JwtDecoder.decode(widget.token);
    email = decodedToken['email'] ?? "No Email";
  }

  void _logout() {

    // await secureStorage.delete(key: 'token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Student Page"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Logged in as:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _logout,
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
