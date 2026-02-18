import 'package:flutter/material.dart';
import '../screens/tutor_home_page.dart';
import '../screens/sessions_page.dart';
import '../screens/students_page.dart';
import '../screens/earnings_page.dart';
import '../screens/notifications_page.dart';
import '../navigation/tutor_tab_container.dart';

class TutorNavigation extends StatefulWidget {
  const TutorNavigation({Key? key}) : super(key: key);

  @override
  State<TutorNavigation> createState() => _TutorNavigationState();
}

class _TutorNavigationState extends State<TutorNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    TutorHomePage(),
    SessionsPage(),
    StudentsPage(),
    EarningsPage(),
    NotificationsPage(),
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