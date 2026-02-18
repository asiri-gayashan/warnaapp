import 'package:flutter/material.dart';
import 'package:warna_app/features/auth/ui/screens/login/login_screen.dart';
import '../../../../shared/widgets/student_tab_container.dart';
import '../../../../features/student/ui/screens/home_page.dart';
import '../../../../features/student/ui/screens/profile_page.dart';
import '../../../../features/student/ui/screens/classes_page.dart';
import '../../../../features/student/ui/screens/notifications_page.dart';
import '../../../../features/student/ui/screens/record_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class StudentNavigation extends StatefulWidget {
  final String token;

  const StudentNavigation({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<StudentNavigation> createState() => _StudentNavigationState();
}

class _StudentNavigationState extends State<StudentNavigation> {
  int _selectedIndex = 0;
  // late

  void _logout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  void _checkToken() {
    if (widget.token.isEmpty) {
      _logout();
      return;
    }

    bool isExpired = JwtDecoder.isExpired(widget.token);

    if (isExpired) {
      _logout();
    }
  }


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