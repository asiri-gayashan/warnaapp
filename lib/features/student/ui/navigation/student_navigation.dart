import 'package:flutter/material.dart';
import '../../../../shared/widgets/student_tab_container.dart';
import '../../../../features/student/ui/screens/home_page.dart';
import '../../../../features/student/ui/screens/profile_page.dart';
import '../../../../features/student/ui/screens/classes_page.dart';
import '../../../../features/student/ui/screens/notifications_page.dart';
import '../../../../features/student/ui/screens/record_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class StudentNavigation extends StatefulWidget {
  final token;
  const StudentNavigation({
    @required this.token,
    Key? key,

  }) : super(key: key);

  @override
  State<StudentNavigation> createState() => _StudentNavigationState();
}

class _StudentNavigationState extends State<StudentNavigation> {
  int _selectedIndex = 0;
  // late
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    ClassesPage(),
    NotificationsPage(),
    PaymentRecordsPage(),
    ProfilePage(),

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