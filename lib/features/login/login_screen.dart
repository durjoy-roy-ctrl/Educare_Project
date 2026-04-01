/*import 'package:flutter/material.dart';
import '../../navigation/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showWarning = false;
  bool rememberMe = false;
  bool _obscurePassword = true;

  static const Color primaryBlue = Color(0xff261CC1);

  void handleLogin() {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        showWarning = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            showWarning = false;
          });
        }
      });

      return;
    }

    /// Navigate to MainNavigation and pass data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigation(
          userName: passwordController.text,
          phone: phoneController.text,
          initialIndex: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    /// Logo
                    Image.asset('assets/images/educare1_logo.png', height: 150),

                    const Text(
                      "EDUCARE",
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Phone Input
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: const Icon(Icons.phone),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Password Input
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword, // link to the toggle
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword; // toggle visibility
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),

                        onPressed: handleLogin,
                        child: const Text("Login"),
                      ),
                    ),

                    const SizedBox(height: 20),


                    ///Signup Button
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: Text("Don't have an account? Sign Up"),
        )







                  ],
                ),
              ),
            ),
          ),

          /// WARNING BANNER
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),

            top: 60,
            right: showWarning ? 20 : -350,

            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: const Color(0xffece1d1),
                borderRadius: BorderRadius.circular(12),

                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),

              child: const Text(
                "Must Input Something",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../navigation/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showWarning = false;
  bool _obscurePassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => showWarning = true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => showWarning = false);
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // 1. Initialize variables to hold user data
      String role = "";
      DocumentSnapshot<Map<String, dynamic>>? doc;

      // 2. Check plural 'students' first (to match your Signup logic)
      doc = await _firestore.collection('students').doc(uid).get();

      if (doc.exists) {
        role = 'students'; // Match the collection name exactly
      } else {
        // 3. Check plural 'teachers'
        doc = await _firestore.collection('teachers').doc(uid).get();
        if (doc.exists) {
          role = 'teachers'; // Match the collection name exactly
        } else {
          throw Exception('User data not found in Firestore');
        }
      }

      if (mounted) {
        // 4. Pass the role to MainNavigation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(
              userName: doc!.data()!['name'],
              phone: doc.data()!['phone'],
              role: role,
              initialIndex: 0,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset('assets/images/educare1_logo.png', height: 150),
                  const Text("EDUCARE",
                      style: TextStyle(
                          color: Color(0xff261CC1),
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),

                  // Email
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff261CC1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Login"),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Signup navigation
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),

          // Warning
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: 60,
            right: showWarning ? 20 : -350,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffece1d1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: const Text(
                "Must Input Something",
                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

