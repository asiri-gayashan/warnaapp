import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warna_app/core/utils/token_service.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/router/router.dart';
import 'package:warna_app/router/router_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToNext();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final user = await UserService.getUser();
    final accessToken = await TokenService.getAccessToken();
    final refreshToken = await TokenService.getRefreshToken();

    if (accessToken != null && refreshToken != null && user != null) {
      print(user);

      switch (user["role"]) {
        case "STUDENT":
          if (context.mounted) {
            GoRouter.of(context).goNamed(studentRouteNames.dashboard);
          }
        case "TUTOR":
          if (context.mounted) {
            GoRouter.of(context).goNamed(tutorRouteNames.dashboard);
          }
        case "INSTITUTE":
          if (context.mounted) {
            GoRouter.of(context).goNamed(InstituteRouteNames.dashboard);
          }
      }
    } else {
      RouterClass.router.goNamed(RouterNames.loginScreen);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 96, 169, 236), // bright sky blue
              Color(0xFF2E7DD4), // mid blue
              Color(0xFF0064e0), // deeper blue
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main centered content
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Brand name — large, bold, clean
                        const Text(
                          'WARNA',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'poppins',
                            height: 1.0,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Tagline

                        // Subtitle
                        Text(
                          'A Cross-Platform Institute & Teacher\nManagement System for Tuition Services',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.85),
                            letterSpacing: 0.2,
                            height: 1.6,
                            fontFamily: 'Instrument Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom loading dots
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      _PulsingDots(),
                      const SizedBox(height: 24),
                      Text(
                        '© 2024 WARNA. All rights reserved.',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.40),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Three small animated dots as a minimal loading indicator
class _PulsingDots extends StatefulWidget {
  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = ((_controller.value - delay) % 1.0 + 1.0) % 1.0;
        final scale = 0.6 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(0.0),
        const SizedBox(width: 8),
        _dot(0.2),
        const SizedBox(width: 8),
        _dot(0.4),
      ],
    );
  }
}
