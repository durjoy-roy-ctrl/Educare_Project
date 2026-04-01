import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EduCare App',
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xff261CC1),
            scaffoldBackgroundColor: const Color(0xffF8F9FD),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xff261CC1), foregroundColor: Colors.white),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.indigo,
            scaffoldBackgroundColor: Colors.black87,
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xff1A1480), foregroundColor: Colors.white),
          ),
          home: const HomePage(username: "Abdur Rafi Hasan", phone: "017XXXXXXXX"),
        );
      },
    );
  }
}

Future<void> _launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $urlString');
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return IconButton(
          icon: Icon(mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
          onPressed: () => themeNotifier.value = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;
  final String phone;
  const HomePage({super.key, required this.username, required this.phone});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> premiumCourses = [
    {"title": "C++ Masterclass", "instructor": "Google Developers", "url": "https://www.udemy.com/topic/c-plus-plus/"},
    {"title": "Mastering DSA", "instructor": "Abdul Bari", "url": "https://www.udemy.com/course/datastructurescncpp/"},
    {"title": "Python for AI", "instructor": "Andrew Ng", "url": "https://www.coursera.org/learn/ai-python-for-beginners"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hi, ${widget.username}"), actions: const [ThemeToggleButton()]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xff261CC1)),
              currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Color(0xff261CC1))),
              accountName: Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(widget.phone),
            ),
            ListTile(leading: const Icon(Icons.home_outlined), title: const Text("Home"), onTap: () => Navigator.pop(context)),
            ListTile(
                leading: const Icon(Icons.question_answer_outlined),
                title: const Text("Q&A (Ask a Question)"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QnaPage(username: widget.username)));
                }
            ),
            ListTile(leading: const Icon(Icons.settings_outlined), title: const Text("Settings"), onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            }),
            ListTile(leading: const Icon(Icons.info_outline), title: const Text("About Us"), onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsPage()));
            }),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () {}
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Premium Courses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: premiumCourses.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xff261CC1), Color(0xff4A3AFF)]),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(premiumCourses[index]['title']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(premiumCourses[index]['instructor']!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => _launchURL(premiumCourses[index]['url']!),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xff261CC1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: const Text("Enroll Now"),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QnaPage extends StatefulWidget {
  final String username;
  const QnaPage({super.key, required this.username});

  @override
  State<QnaPage> createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitQuestion() async {
    if (_controller.text.isNotEmpty) {
      try {
        await _firestore.collection('questions').add({
          'questionText': _controller.text,
          'senderName': widget.username,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _controller.clear();
        FocusScope.of(context).unfocus();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Q&A Section"), actions: const [ThemeToggleButton()]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type your question here...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Color(0xff261CC1)),
                  onPressed: _submitQuestion,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent Questions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('questions').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Center(child: Text("Something went wrong"));
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text("No questions yet. Be the first to ask!"));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xff261CC1),
                            child: Icon(Icons.question_answer, color: Colors.white, size: 18),
                          ),
                          title: Text(data['questionText'] ?? "", style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text("By: ${data['senderName'] ?? "Student"}", style: const TextStyle(fontSize: 12)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = "English";

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text("English"),
              value: "English",
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), actions: const [ThemeToggleButton()]),
      body: ListView(
        children: [
          // "Change Password" অপশনটি এখান থেকে সরিয়ে ফেলা হয়েছে।
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xff261CC1)),
            title: const Text("Language"),
            subtitle: Text(selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showLanguageDialog,
          ),
          const Divider(),
          const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("App Version 1.0.0", style: TextStyle(color: Colors.grey))
          ),
        ],
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us"), actions: const [ThemeToggleButton()]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: Text("About EduCare", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff261CC1)))),
          const SizedBox(height: 12),
          const Text(
            "EduCare is a modern educational companion designed to simplify learning for students. Our platform provides a centralized hub where users can explore academic courses, track upcoming exams, and stay updated with the latest university notices.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          const Text("Project Developers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildMemberCard("DURJOY ROY", "00724105101055"),
          _buildMemberCard("ABDUR RAFI HASAN", "00724105101067"),
          _buildMemberCard("Amdadul Hasan Sinha", "00724105101069"),
        ],
      ),
    );
  }

  Widget _buildMemberCard(String name, String id) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xff261CC1), child: Icon(Icons.person, color: Colors.white, size: 20)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text("Student ID: $id", style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}