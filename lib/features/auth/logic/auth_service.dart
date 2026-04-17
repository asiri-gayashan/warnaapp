import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warna_app/core/utils/token_service.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/router/router.dart';
import 'package:warna_app/router/router_names.dart';

class AuthService {
  static Future<void> logoutUser({BuildContext? context}) async {
    await TokenService.clearTokens();
    await UserService.clearUser();

    if (context != null && context.mounted) {
      GoRouter.of(context).goNamed(RouterNames.loginScreen);
    } else {
      RouterClass.router.goNamed(RouterNames.loginScreen);
    }
  }
}




// Future<void> logout() async {
//   try {
//     final refreshToken = await TokenService.getRefreshToken();
//     await Dio().post('https://yourapi.com/auth/logout', data: {
//       'refreshToken': refreshToken,
//     });
//   } catch (_) {
//     // continue even if server call fails
//   } finally {
//     await TokenService.clearTokens(); // clears secure storage
//     await UserService.clearUser();    // clears shared preferences

//     Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//   }
// }