import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_top_section.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, Rain daddy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Set grade",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white70),
                ),
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.search,
                        color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text("Search", style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),

        // 🧩 Cards Section (Attached to bottom)
        const Positioned(
          bottom: 70,
          left: 0,
          right: 0,
          child: HomeTopSection(),
        ),
      ],
    );
  }
}
