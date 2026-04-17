import 'package:flutter/material.dart';
import 'package:warna_app/presentation/institute/navigation/institute_tab_container.dart';
import 'package:warna_app/presentation/institute/screens/institute_finance_page.dart';
import 'package:warna_app/presentation/institute/screens/institute_dashboard_page.dart';
import 'package:warna_app/presentation/institute/screens/tutor/institute_tutors_page.dart';
import 'package:warna_app/presentation/institute/screens/student/institute_students_page.dart';
import 'package:warna_app/presentation/institute/screens/classes/institute_courses_page.dart';
// import 'package:warna_app/features/institute/ui/screens/institute_reports_page.dart';

class InstituteNavigation extends StatefulWidget {
  const InstituteNavigation({Key? key}) : super(key: key);

  @override
  State<InstituteNavigation> createState() => _InstituteNavigationState();
}

class _InstituteNavigationState extends State<InstituteNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    InstituteDashboardPage(),
    InstituteTutorsPage(),
    InstituteStudentsPage(),
    InstituteCoursesPage(),
    // InstituteReportsPage(),
    InstituteFinancePage()
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
      bottomNavigationBar: InstituteTabContainer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}