import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'home_top_section.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onLogout; // Add this

  const HomeHeader({super.key, this.onLogout}); // Update constructor

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: UserService.getUser().then((user) => user?['fullName'] as String?),
      builder: (context, snapshot) {
        String fullName = snapshot.data ?? "User";

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 🔵 Blue Header Background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 250),
              decoration: const BoxDecoration(
                color: Color(0xFF3D5AFE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, $fullName",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Grade 9",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onLogout, // Use the callback
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout_outlined, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Cards Section
            const Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: HomeTopSection(),
            ),
          ],
        );
      },
    );
  }
}