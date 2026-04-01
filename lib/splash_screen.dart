/*import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showCurtains = true;
  bool showLogo = false;
  bool showText = false;

  // Color Palette Constants
  final Color brandBlue = const Color(0xFF728FE3); // Deep Royal Blue
  final Color backgroundWhite = const Color(0xFF07437E); // Ghost White
  final Color textDark = const Color(0xFF0F172A); // Slate Navy

  @override
  void initState() {
    super.initState();

    // Initial delay before curtains open
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => showCurtains = false);
    });

    // Logo fades in after curtains start moving
    Future.delayed(const Duration(milliseconds: 1400), () {
      setState(() => showLogo = true);
    });

    // Typography slides in
    Future.delayed(const Duration(milliseconds: 2400), () {
      setState(() => showText = true);
    });

    // Navigate to Home
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundWhite,
      body: Stack(
        children: [
          // MAIN CONTENT LAYER
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: showLogo ? 1 : 0,
                  duration: const Duration(milliseconds: 1000),
                  child: AnimatedScale(
                    scale: showLogo ? 1.7 : 0.7, // Subtle scale up effect
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves
                        .elasticOut, // Added a slight bounce for character
                    child: Image.asset(
                      'assets/images/educare_logo.png',
                      width: 300,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedSlide(
                  offset: showText ? Offset.zero : const Offset(0, 0.5),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: showText ? 1 : 0,
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Educare',
                      style: TextStyle(
                        fontFamily: 'Gremio', // Ensure this is in pubspec.yaml
                        fontSize: 42,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                        color: Colors
                            .white, // Using the primary brand color for the name
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LEFT CURTAIN
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutQuart,
            left: showCurtains ? 0 : -size.width / 2,
            top: 0,
            bottom: 0,
            width: size.width / 2,
            child: Container(
              decoration: BoxDecoration(
                color: brandBlue,
                border: Border(
                  right: BorderSide(color: Colors.white10, width: 1),
                ),
              ),
            ),
          ),

          // RIGHT CURTAIN
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutQuart,
            right: showCurtains ? 0 : -size.width / 2,
            top: 0,
            bottom: 0,
            width: size.width / 2,
            child: Container(
              decoration: BoxDecoration(
                color: brandBlue,
                border: Border(
                  left: BorderSide(color: Colors.white10, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showCurtains = true;
  bool showLogo = false;
  bool showText = false;

  final Color brandBlue = const Color(0xFF728FE3);
  final Color backgroundWhite = const Color(0xFF07437E);

  @override
  void initState() {
    super.initState();

    // Firebase test
    testRead();

    // Animation sequence
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => showCurtains = false);
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      setState(() => showLogo = true);
    });

    Future.delayed(const Duration(milliseconds: 2400), () {
      setState(() => showText = true);
    });

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  // Firebase read function (Realtime Database)
  void testRead() async {
    try {
      final ref = FirebaseDatabase.instance
          .ref("quizzes/flutter_basics_quiz/questions");

      final snapshot = await ref.get();

      if (snapshot.exists) {
        print("✅ Firebase read: ${snapshot.value}");
      } else {
        print("❌ No data found");
      }
    } catch (e) {
      print("❌ Firebase error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundWhite,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: showLogo ? 1 : 0,
                  duration: const Duration(milliseconds: 1000),
                  child: AnimatedScale(
                    scale: showLogo ? 1.7 : 0.7,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.elasticOut,
                    child: Image.asset(
                      'assets/images/educare_logo.png',
                      width: 300,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedSlide(
                  offset: showText ? Offset.zero : const Offset(0, 0.5),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: showText ? 1 : 0,
                    duration: const Duration(milliseconds: 800),
                    child: const Text(
                      'Educare',
                      style: TextStyle(
                        fontFamily: 'Gremio',
                        fontSize: 42,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutQuart,
            left: showCurtains ? 0 : -size.width / 2,
            top: 0,
            bottom: 0,
            width: size.width / 2,
            child: Container(color: brandBlue),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutQuart,
            right: showCurtains ? 0 : -size.width / 2,
            top: 0,
            bottom: 0,
            width: size.width / 2,
            child: Container(color: brandBlue),
          ),
        ],
      ),
    );
  }
}
