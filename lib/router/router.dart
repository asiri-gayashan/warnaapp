import 'package:go_router/go_router.dart';
import 'package:warna_app/features/auth/ui/screens/login/login_screen.dart';
import 'package:warna_app/features/institute/ui/screens/class_detail_page.dart';
import 'package:warna_app/features/institute/ui/screens/enroll_student_page.dart';
import 'package:warna_app/features/institute/ui/screens/fees_attendance_page.dart';
import 'package:warna_app/features/institute/ui/screens/institute_courses_page.dart';
import 'package:warna_app/features/institute/ui/screens/institute_create_class.dart';
import 'package:warna_app/features/institute/ui/screens/institute_dashboard_page.dart';
import 'package:warna_app/features/institute/ui/screens/institute_edit_class.dart';
import 'package:warna_app/features/institute/ui/screens/institute_finance_page.dart';
import 'package:warna_app/features/institute/ui/screens/institute_students_page.dart';
import 'package:warna_app/features/institute/ui/screens/institute_tutors_page.dart';
import 'package:warna_app/features/institute/ui/screens/mark_attendance_page.dart';
import 'package:warna_app/features/institute/ui/screens/mark_payement_teachers_page.dart';
import 'package:warna_app/features/institute/ui/screens/mark_payment_page.dart';
import 'package:warna_app/features/institute/ui/screens/student_detail_page.dart';
import 'package:warna_app/features/institute/ui/screens/tutor_detail_page.dart';
import 'package:warna_app/features/test2.dart';
import 'package:warna_app/features/test_student_page.dart';
import 'package:warna_app/features/tutor/ui/screens/create_class_page.dart';
import 'package:warna_app/router/router_names.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    // errorPageBuilder:  ,
    routes: [
      GoRoute(
        path: "/",
        name: RouterNames.testPage,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      // --------------------------------------------------------------------extra data passing example-------------------------------------------------
      // GoRoute(
      //   path: "/testwithdata",
      //   name: "testwithdata",
      //   builder: (context, state) {
      //     final userName = (state.extra as Map<String, dynamic>)["name"] as String;
      //     final age = (state.extra as Map<String, dynamic>)["age"] as String;
      //     return  TestWithData(userName: userName, age: age);
      //   },
      // ),

      // --------------------------------------------------------------------path parameter data  passing example-------------------------------------------------
      // GoRoute(
      //   path: "/testwithdata/:name",
      //   name: "testwithdata",
      //   builder: (context, state) {
      //     return TestWithData(userName: state.pathParameters["name"]! );
      //   },
      // ),
      GoRoute(
        path: "/testwithdata/:name",
        name: "testwithdata",
        builder: (context, state) {
          return TestWithData(userName: state.pathParameters["name"]!);
        },
      ),

      //---------------------------------------------------------------Institute Dashboard routes-------------------------------------------------
      GoRoute(
    path: "/institute/dashboard",
    name: InstituteRouteNames.dashboard,
    builder: (context, state) => const InstituteDashboardPage(),
  ),

  GoRoute(
    path: "/institute/classes",
    name: InstituteRouteNames.courses,
    builder: (context, state) =>  InstituteCoursesPage(),
  ),

  GoRoute(
    path: "/institute/classes/create",
    name: InstituteRouteNames.createClass,
    builder: (context, state) => InstituteCreateClassPage(),
  ),

  GoRoute(
    path: "/institute/classes/edit",
    name: InstituteRouteNames.editClass,
    builder: (context, state) {
      return InstituteEditClassPage();
    },
  ),

  GoRoute(
    path: "/institute/classes/details",
    name: InstituteRouteNames.classDetail,
    builder: (context, state) {
      return ClassDetailPage();
    },
  ),

  GoRoute(
    path: "/institute/students",
    name: InstituteRouteNames.students,
    builder: (context, state) => InstituteStudentsPage(),
  ),

  GoRoute(
    path: "/institute/students/enroll",
    name: InstituteRouteNames.enrollStudent,
    builder: (context, state) => const EnrollStudentPage(),
  ),

  GoRoute(
    path: "/institute/students/:id",
    name: InstituteRouteNames.studentDetail,
    builder: (context, state) {
      return StudentDetailPage(student: {},);
    },
  ),

  GoRoute(
    path: "/institute/tutors",
    name: InstituteRouteNames.tutors,
    builder: (context, state) => const InstituteTutorsPage(),
  ),

  GoRoute(
    path: "/institute/tutors/:id",
    name: InstituteRouteNames.tutorDetail,
    builder: (context, state) {
      return TutorDetailPage(tutor: {},);
    },
  ),

  GoRoute(
    path: "/institute/finance",
    name: InstituteRouteNames.finance,
    builder: (context, state) => InstituteFinancePage(),
  ),

  GoRoute(
    path: "/institute/fees-attendance",
    name: InstituteRouteNames.feesAttendance,
    builder: (context, state) => FeesAttendancePage(),
  ),

  GoRoute(
    path: "/institute/classes/attendance/:id",
    name: InstituteRouteNames.markAttendance,
    builder: (context, state) {
      return MarkAttendancePage();
    },
  ),

  GoRoute(
    path: "/institute/classes/payment",
    name: InstituteRouteNames.markPayment,
    builder: (context, state) {
      return MarkPaymentPage();
    },
  ),

  GoRoute(
    path: "/institute/tutors/payment/:id",
    name: InstituteRouteNames.markPaymentTeachers,
    builder: (context, state) {
      return InstituteMarkPaymentPage();
    },
  ),

    ],
  );
}
