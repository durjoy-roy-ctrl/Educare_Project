import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String phone;

  const ProfilePage({super.key, required this.userName, required this.phone});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String name;
  late String phone;

  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController phoneController;

  static const Color primaryBlue = Color(0xFF4169E1);

  @override
  void initState() {
    super.initState();

    name = widget.userName;
    phone = widget.phone;

    nameController = TextEditingController(text: name);
    phoneController = TextEditingController(text: phone);


    nameController.addListener(_onTextChanged);
    phoneController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (isEditing) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    nameController.removeListener(_onTextChanged);
    phoneController.removeListener(_onTextChanged);

    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  /// User Data Edit
  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;

      if (isEditing) {
        nameController.text = name;
        phoneController.text = phone;
      }
    });
  }


  void saveProfile() {
    setState(() {
      name = nameController.text.trim();
      phone = phoneController.text.trim();
      isEditing = false;
    });
  }


  bool get isChanged =>
      nameController.text.trim() != name ||
          phoneController.text.trim() != phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        actions: [
          TextButton(
            onPressed: toggleEdit,
            child: Text(
              isEditing ? "Cancel" : "Edit Profile",
              style: const TextStyle(color: primaryBlue),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Avatar
            const CircleAvatar(
              radius: 55,
              backgroundColor: primaryBlue,
              child: Icon(Icons.person, size: 55, color: Colors.white),
            ),

            const SizedBox(height: 20),


            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),

              child: isEditing
                  ? Column(
                key: const ValueKey("edit"),
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              )
                  : Column(
                key: const ValueKey("view"),
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(phone, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// Save Button
            if (isEditing)
              ElevatedButton(
                onPressed: isChanged ? saveProfile : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),

                child: const Text("Save Profile"),
              ),

            const SizedBox(height: 40),

            /// Track Record
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),

                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          fontSize: 20,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Enrolled"),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          fontSize: 20,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Completed"),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          fontSize: 20,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Ongoing"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// Logout Button
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },

              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryBlue),
                foregroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),

              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
