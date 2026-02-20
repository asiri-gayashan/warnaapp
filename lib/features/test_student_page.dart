import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:warna_app/features/auth/ui/screens/login/login_screen.dart';
import 'package:warna_app/services/token_service.dart';
// import 'core/services/token_service.dart';

class TestStudentPage extends StatefulWidget {
  const TestStudentPage({Key? key}) : super(key: key);

  @override
  State<TestStudentPage> createState() => _TestStudentPageState();
}

class _TestStudentPageState extends State<TestStudentPage> {
  Map<String, dynamic>? decodedToken;
  String email = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  /// Load token globally
  Future<void> _loadToken() async {
    String? token = await TokenService.getToken();

    if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
      _logout();
      return;
    }

    decodedToken = JwtDecoder.decode(token);

    setState(() {
      email = decodedToken?['email'] ?? "No Email";
      loading = false;
    });
  }

  /// Logout
  Future<void> _logout() async {
    await TokenService.clearToken();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
