import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:educare/navigation/main_navigation.dart';
import 'splash_screen.dart';
import 'features/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigation(
          initialIndex: 0,
          phone: "0000000000",
          userName: "Guest",
        ),
      },
    );
  }
}