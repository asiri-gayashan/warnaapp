import 'package:flutter/material.dart';
import 'package:warna_app/presentation/student/navigation/student_tab_container.dart';
import 'package:warna_app/presentation/student/screens/student_dashboard_page.dart';
import 'package:warna_app/presentation/student/screens/classes/student_classes_page.dart';
import 'package:warna_app/presentation/student/screens/tutor/student_tutors_page.dart';
import 'package:warna_app/presentation/student/screens/institute/student_institutes_page.dart';
import 'package:warna_app/presentation/student/screens/student_finance_page.dart';

class StudentNavigation extends StatefulWidget {
  const StudentNavigation({Key? key}) : super(key: key);

  @override
  State<StudentNavigation> createState() => _StudentNavigationState();
}

class _StudentNavigationState extends State<StudentNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    StudentDashboardPage(),
    StudentClassesPage(),
    StudentTutorsPage(),
    StudentInstitutesPage(),
    StudentFinancePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: StudentTabContainer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
