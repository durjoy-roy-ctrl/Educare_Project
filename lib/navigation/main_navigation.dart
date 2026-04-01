import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/courses/courses_page.dart';
import '../features/exams/exams_page.dart';
import '../features/profile/profile_page.dart';

class MainNavigation extends StatefulWidget {
  final String userName;
  final String phone;
  final int initialIndex;

  const MainNavigation({
    super.key,
    required this.userName,
    required this.phone,
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

    _pages = [
      HomePage(
        username: widget.userName,
        phone: widget.phone,
      ),
      const CoursesPage(),
      const ExamsPage(),
      ProfilePage(
        userName: widget.userName,
        phone: widget.phone,
      ),
    ];
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

        destinations: const [
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
        ],
      ),
    );
  }
}
