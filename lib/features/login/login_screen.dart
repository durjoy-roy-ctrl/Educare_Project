import 'package:flutter/material.dart';
import '../../navigation/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool showWarning = false;
  bool rememberMe = false;

  static const Color primaryBlue = Color(0xff261CC1);

  void handleLogin() {
    if (phoneController.text.isEmpty || usernameController.text.isEmpty) {
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
          userName: usernameController.text,
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

                    /// Username Input
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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

                    const SizedBox(height: 12),


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
