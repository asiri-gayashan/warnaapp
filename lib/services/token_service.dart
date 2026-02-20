import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  static const String _tokenKey = "token";

  /// Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Clear token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Decode token (central place)
  static Future<Map<String, dynamic>?> getDecodedToken() async {
    String? token = await getToken();

    if (token == null || token.isEmpty) return null;

    if (JwtDecoder.isExpired(token)) return null;

    return JwtDecoder.decode(token);
  }

  /// Get Email
  static Future<String?> getEmail() async {
    final decoded = await getDecodedToken();
    return decoded?['email'];
  }

  /// Get Full Name
  static Future<String?> getFullName() async {
    final decoded = await getDecodedToken();
    return decoded?['fullname'];
  }

  /// Get Role
  static Future<String?> getRole() async {
    final decoded = await getDecodedToken();
    return decoded?['role'];
  }

  /// Get User ID
  static Future<String?> getUserId() async {
    final decoded = await getDecodedToken();
    return decoded?['id']?.toString();
  }
}
