import 'package:flutter/material.dart';
import 'menu_card.dart';

class HomeTopSection extends StatelessWidget {
  const HomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 30),
      child: SizedBox(
        height: 160,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: const [
            MenuCard(
              icon: Icons.book,
              color: Colors.blue,
              title: "Admission policy",
              subtitle: "223 services",
            ),
            SizedBox(width: 16),
            MenuCard(
              icon: Icons.description,
              color: Colors.orange,
              title: "School Profile",
              subtitle: "47 articles",
            ),
            SizedBox(width: 16),
            MenuCard(
              icon: Icons.info,
              color: Colors.purple,
              title: "Admission info",
              subtitle: "74 articles",
            ),
          ],
        ),
      ),
    );
  }
}
