import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String phone;

  const HomePage({super.key, required this.username, required this.phone});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  bool isDarkMode = false;

  final List<Map<String, dynamic>> categories = [
    {"title": "Courses", "icon": Icons.menu_book, "color": Colors.blue},
    {"title": "Exams", "icon": Icons.assignment, "color": Colors.orange},
    {"title": "Results", "icon": Icons.bar_chart, "color": Colors.green},
    {"title": "Notice", "icon": Icons.notifications, "color": Colors.purple},
  ];


  List<Map<String, dynamic>> filteredCategories = [];

  @override
  void initState() {
    super.initState();

    filteredCategories = categories;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = categories;
    } else {
      results = categories
          .where((user) =>
          user["title"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredCategories = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? const Color(0xff121212) : const Color(0xffF8F9FD);
    Color cardColor = isDarkMode ? const Color(0xff1E1E1E) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color subTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      drawer: Drawer(
        backgroundColor: bgColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xff261CC1)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xff261CC1)),
              ),
              accountName: Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(widget.phone),
            ),
            _drawerItem(Icons.home, "Home", () => Navigator.pop(context), textColor),
            _drawerItem(Icons.question_answer, "Q&A / Help Desk", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DummyPage(title: "Q&A Section")));
            }, textColor),
            _drawerItem(Icons.book, "My Courses", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DummyPage(title: "My Courses")));
            }, textColor),
            _drawerItem(Icons.download, "Downloads", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DummyPage(title: "Downloads")));
            }, textColor),
            _drawerItem(Icons.star_rate, "Ranking", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DummyPage(title: "Ranking")));
            }, textColor),
            const Divider(),
            _drawerItem(Icons.help_center, "Help & Support", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DummyPage(title: "Support")));
            }, textColor),
            _drawerItem(Icons.policy, "Privacy Policy", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DummyPage(title: "Privacy Policy")));
            }, textColor),
            const Spacer(),
            _drawerItem(Icons.logout, "Logout", () {
              Navigator.pushReplacementNamed(context, '/login');
            }, Colors.red),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            pinned: true,
            backgroundColor: const Color(0xff261CC1),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 55, bottom: 16),
              title: Text("Hi, ${widget.username}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              background: Container(color: const Color(0xff261CC1)),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'logout') {
                    Navigator.pushReplacementNamed(context, '/login');
                  } else if (value == 'dark_mode') {
                    setState(() { isDarkMode = !isDarkMode; });
                  } else if (value == 'settings') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DummyPage(title: "Settings")));
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'settings', child: ListTile(leading: Icon(Icons.settings, size: 20), title: Text("Settings"))),
                  PopupMenuItem(value: 'dark_mode', child: ListTile(leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 20), title: Text(isDarkMode ? "Light Mode" : "Dark Mode"))),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'logout', child: ListTile(leading: Icon(Icons.logout, color: Colors.red, size: 20), title: Text("Logout", style: TextStyle(color: Colors.red)))),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: TextField(
                      style: TextStyle(color: textColor),
                      controller: searchController,
                      onChanged: (value) => _runFilter(value),
                      decoration: InputDecoration(
                        hintText: "Search categories...",
                        hintStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.black45),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SaleCoursesPage(isDark: isDarkMode)));
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xff4facfe), Color(0xff00f2fe)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("60% OFF", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                Text("On all premium courses", style: TextStyle(color: Colors.white, fontSize: 16)),
                                SizedBox(height: 10),
                                Text("Click to view courses →", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Positioned(
                            right: -10, bottom: -10,
                            child: Icon(Icons.stars, size: 100, color: Colors.white.withOpacity(0.2)),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 15),


                  filteredCategories.isEmpty
                      ? Center(child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("No Category Found!", style: TextStyle(color: textColor, fontSize: 16)),
                  ))
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.8),
                    itemCount: filteredCategories.length, // Filtered list use kora hoyeche
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DummyPage(title: filteredCategories[index]['title']))),
                        child: Column(
                          children: [
                            CircleAvatar(radius: 28, backgroundColor: filteredCategories[index]['color'].withOpacity(0.1), child: Icon(filteredCategories[index]['icon'], color: filteredCategories[index]['color'])),
                            const SizedBox(height: 8),
                            Text(filteredCategories[index]['title'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Continue Learning", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      TextButton(onPressed: () {}, child: const Text("See All")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Container(height: 65, width: 65, decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.play_circle_fill, color: Colors.orange, size: 35)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mathematics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textColor)),
                              Text("Chapter 04: Algebra Basics", style: TextStyle(fontSize: 13, color: subTextColor)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: 0.65, backgroundColor: Colors.grey.withOpacity(0.2), color: const Color(0xff261CC1), minHeight: 6))),
                                  const SizedBox(width: 10),
                                  Text("65%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}


class SaleCoursesPage extends StatelessWidget {
  final bool isDark;
  const SaleCoursesPage({super.key, required this.isDark});

  final List<Map<String, dynamic>> saleItems = const [
    {"title": "C++ Mastery Course", "tag": "Best Seller", "price": "400", "oldPrice": "1000", "icon": Icons.code},
    {"title": "DSA: Basic to Advance", "tag": "Hardcore", "price": "800", "oldPrice": "2000", "icon": Icons.data_array},
    {"title": "Learning English (Spoken)", "tag": "Fluent", "price": "320", "oldPrice": "800", "icon": Icons.abc},
    {"title": "C Programming Zero to Hero", "tag": "Beginner", "price": "240", "oldPrice": "600", "icon": Icons.terminal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xff121212) : const Color(0xffF8F9FD),
      appBar: AppBar(
        title: const Text("Flash Sale - 60% OFF"),
        backgroundColor: const Color(0xff261CC1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: saleItems.length,
        itemBuilder: (context, index) {
          final item = saleItems[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(color: const Color(0xff261CC1).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(item['icon'], color: const Color(0xff261CC1), size: 40),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(5)),
                        child: Text(item['tag'], style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 5),
                      Text(item['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text("৳${item['price']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                          const SizedBox(width: 8),
                          Text("৳${item['oldPrice']}", style: const TextStyle(fontSize: 13, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add_shopping_cart, color: Color(0xff261CC1))),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xff261CC1), foregroundColor: Colors.white, title: Text(title)),
      body: Center(child: Text("Welcome to $title", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xff261CC1)))),
    );
  }
}