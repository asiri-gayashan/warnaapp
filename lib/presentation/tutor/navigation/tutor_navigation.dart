import 'package:flutter/material.dart';
import 'package:warna_app/presentation/tutor/navigation/tutor_tab_container.dart';
import 'package:warna_app/presentation/tutor/screens/tutor_dashboard_page.dart';
import 'package:warna_app/presentation/tutor/screens/classes/tutor_classes_page.dart';
import 'package:warna_app/presentation/tutor/screens/student/tutor_students_page.dart';
import 'package:warna_app/presentation/tutor/screens/tutor_finance_page.dart';
import 'package:warna_app/presentation/tutor/screens/institute/tutor_institutes_page.dart';

class TutorNavigation extends StatefulWidget {
  const TutorNavigation({Key? key}) : super(key: key);

  @override
  State<TutorNavigation> createState() => _TutorNavigationState();
}

class _TutorNavigationState extends State<TutorNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    TutorDashboardPage(),
    TutorClassesPage(),
    TutorStudentsPage(),
    TutorInstitutesPage(),
    TutorFinancePage(),
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
      bottomNavigationBar: TutorTabContainer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
