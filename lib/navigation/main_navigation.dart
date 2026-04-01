import 'package:flutter/material.dart';

import '../features/student/courses/courses_page.dart';
import '../features/student/exams/exams_page.dart';
import '../features/student/home/home_page.dart';
import '../features/student/profile/profile_page.dart';
import '../features/teacher/profile/TeacherProfile.dart';
import '../features/teacher/Q & A/questionAnswer.dart';
import '../features/teacher/TeacherDashboard/dashboard.dart';


class MainNavigation extends StatefulWidget {
  final String userName;
  final String phone;
  final String role;
  final int initialIndex;

  const MainNavigation({
    super.key,
    required this.userName,
    required this.phone,
    required this.role,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;


    if (widget.role.toLowerCase() == 'teacher') {
      _pages = [
        teacherProfile(
          userName: widget.userName,
          phone: widget.phone,
          role: widget.role,
        ),
        const dashboard(),
        const questionAnswer(),
      ];
    }

    else {
      _pages = [
        const HomePage(),
        const CoursesPage(),
        const ExamsPage(),
        ProfilePage(
          userName: widget.userName,
          phone: widget.phone,
          role: widget.role,
        ),
      ];
    }
  }

  List<NavigationDestination> _getDestinations() {
    if (widget.role.toLowerCase() == 'teacher') {
      return const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          selectedIcon: Icon(Icons.add_circle),
          label: "Creator",
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: "Analytics",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ];
    } else {
      // Original Student Destinations
      return const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book),
          label: "Courses",
        ),
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          selectedIcon: Icon(Icons.assignment),
          label: "Exams",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,

      //   destinations: const [
      //     NavigationDestination(
      //       icon: Icon(Icons.home_outlined),
      //       selectedIcon: Icon(Icons.home),
      //       label: "Home",
      //     ),
      //
      //     NavigationDestination(
      //       icon: Icon(Icons.menu_book_outlined),
      //       selectedIcon: Icon(Icons.menu_book),
      //       label: "Courses",
      //     ),
      //
      //     NavigationDestination(
      //       icon: Icon(Icons.assignment_outlined),
      //       selectedIcon: Icon(Icons.assignment),
      //       label: "Exams",
      //     ),
      //
      //     NavigationDestination(
      //       icon: Icon(Icons.person_outline),
      //       selectedIcon: Icon(Icons.person),
      //       label: "Profile",
      //     ),
      //   ],
      // ),

        destinations: _getDestinations(),
      ),
    );
  }
}


