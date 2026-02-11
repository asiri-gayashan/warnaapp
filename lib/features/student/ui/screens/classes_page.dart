import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  void _onClassTap(String name) {
    debugPrint("Tapped class: $name"); // dummy function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // 🔵 CLASSES TODAY
            _sectionHeader("Classes Today"),
            const SizedBox(height: 12),
            ClassCard(
              image:
              "https://images.unsplash.com/photo-1492724441997-5dc865305da7",
              title: "Graphic Design",
              teacher: "Mr. Perera",
              time: "9:00 AM - 11:00 AM",
              isPaid: true,
              attendance: "4/10",
              onTap: () => _onClassTap("Graphic Design"),
            ),
            const SizedBox(height: 20),
            ClassCard(
              image:
              "https://images.unsplash.com/photo-1522202176988-66273c2fd55f",
              title: "UI/UX Design",
              teacher: "Ms. Silva",
              time: "1:00 PM - 3:00 PM",
              isPaid: false,
              attendance: "7/10",
              onTap: () => _onClassTap("UI/UX Design"),
            ),

            const SizedBox(height: 30),

            // 🔵 YOUR CLASSES (GRID)
            _sectionHeader("Your Classes"),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
              children: [
                ClassCard(
                  image:
                  "https://images.unsplash.com/photo-1519389950473-47ba0277781c",
                  title: "App Development",
                  teacher: "Mr. Fernando",
                  time: "Tue 10:00 AM",
                  isPaid: true,
                  attendance: "5/10",
                  onTap: () => _onClassTap("App Dev"),
                ),
                ClassCard(
                  image:
                  "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
                  title: "Web Development",
                  teacher: "Mr. Nimal",
                  time: "Wed 2:00 PM",
                  isPaid: true,
                  attendance: "8/10",
                  onTap: () => _onClassTap("Web Dev"),
                ),
                ClassCard(
                  image:
                  "https://images.unsplash.com/photo-1519389950473-47ba0277781c",
                  title: "App Development",
                  teacher: "Mr. Fernando",
                  time: "Tue 10:00 AM",
                  isPaid: true,
                  attendance: "5/10",
                  onTap: () => _onClassTap("App Dev"),
                ),
                ClassCard(
                  image:
                  "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
                  title: "Web Development",
                  teacher: "Mr. Nimal",
                  time: "Wed 2:00 PM",
                  isPaid: true,
                  attendance: "8/10",
                  onTap: () => _onClassTap("Web Dev"),
                ),
              ],
            ),


            const SizedBox(height: 30),


            const PaginationBar(),

            const SizedBox(height: 30),


            // 🔵 YOUR INSTITUTE
            _sectionHeader("Your Institute"),
            const SizedBox(height: 12),
            _instituteCard(),

            const SizedBox(height: 30),

            // 🔵 YOUR TEACHERS
            _sectionHeader("Your Teachers"),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TeacherAvatar(name: "Kevin C."),
                  TeacherAvatar(name: "Asiri"),
                  TeacherAvatar(name: "Lucas"),
                  TeacherAvatar(name: "Clara T."),
                  TeacherAvatar(name: "Sofia G."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _instituteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primary]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: const [
          Icon(CupertinoIcons.building_2_fill, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("University of Moratuwa",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text("Faculty of Information Technology",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔵 CLASS CARD (DESIGN LIKE IMAGE)
////////////////////////////////////////////////////////////

class ClassCard extends StatelessWidget {
  final String image, title, teacher, time, attendance;
  final bool isPaid;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.image,
    required this.title,
    required this.teacher,
    required this.time,
    required this.isPaid,
    required this.attendance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(image,
                  height: 110, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.person, size: 14),
                      const SizedBox(width: 4),
                      Text(teacher, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.clock, size: 14),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Attendance: $attendance",
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isPaid ? AppColors.primary : AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isPaid ? "PAID" : "UNPAID",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔵 TEACHER AVATAR
////////////////////////////////////////////////////////////

class TeacherAvatar extends StatelessWidget {
  final String name;
  const TeacherAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1527980965255-d3b416303d12"),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}






class PaginationBar extends StatelessWidget {
  const PaginationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pageButton(icon: CupertinoIcons.chevron_left),
        _pageNumber("1", isActive: false),
        _pageNumber("2", isActive: true),
        _pageNumber("3"),
        _pageNumber("4"),
        _pageButton(icon: CupertinoIcons.chevron_right),
      ],
    );
  }

  Widget _pageNumber(String number, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Text(
        number,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _pageButton({required IconData icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Icon(icon, size: 18, color: Colors.blue),
    );
  }
}

