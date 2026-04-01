import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoursesPage(),
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 250,
        title: const Text(
          "All Courses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          courseCard(
            title: "Flutter & Dart Course",
            description: "Learn Flutter from basics to advanced",
            rating: "4.9",
            time: "150 mins",
            image: "assets/images/Flutter_Dart.png",
          ),

          const SizedBox(height: 20),

          courseCard(
            title: "Machine Learning Full Damaka",
            description: "ML concepts and projects",
            rating: "4.7",
            time: "150 mins",
            image: "assets/images/Maching_lerning.jpg",
          ),

          const SizedBox(height: 20),

          courseCard(
            title: "Complete Firebase Explore",
            description: "Database + Authentication",
            rating: "4.7",
            time: "150 mins",
            image: "assets/images/Firebase.jpg",
          ),

          const SizedBox(height: 20),

          courseCard(
            title: "Git & GitHub (free course)",
            description: "Version control system",
            rating: "4.7",
            time: "150 mins",
            image: "assets/images/Git&Github.jpg",
          ),
        ],
      ),
    );
  }

  Widget courseCard({
    required String title,
    required String description,
    required String rating,
    required String time,
    required String image,
  }) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          List<Map<String, String>> videos = [];

          if (title == "Flutter & Dart Course") {
            videos = [
              {
                "title": "Flutter Core Features ",
                "url": "https://youtu.be/SCFTPjgZLQw?si=tyjYEnAwWXovamiH",
              },
              {
                "title":
                    "Flutter Installation and android studio Installation Download",
                "url": "https://youtu.be/UDQ53pjX1CM?si=Z9dBQYksxddNIlS3",
              },
              {
                "title": "Activity & Widget Concept",
                "url": "https://youtu.be/2XERnzaBTVc?si=onV0qgL62Wlyq6Kv",
              },
              {
                "title": "AppBar Flutter",
                "url": "https://youtu.be/vI4EJD4dpZY?si=yo-RlP039q_bzxVt",
              },
              {
                "title": "Row and Column Flutter ",
                "url": "https://youtu.be/UONg5laPu2o?si=RbH4Q1iWS8-D0nFQ",
              },
            ];
          } else if (title == "Machine Learning Full Damaka") {
            videos = [
              {
                "title": "ML Intro",
                "url": "https://youtu.be/Nl3NJB3IJwo?si=45_GrreArESZWgXg",
              },
              {
                "title": "Data",
                "url": "https://youtu.be/32OTiLq3TFQ?si=PcRk5JaiRp21b3G2",
              },
              {
                "title": "Model",
                "url": "https://youtu.be/OCHtT4wJdNA?si=nhZHwIbAKV3BACbI",
              },
              {
                "title": "Training",
                "url": "https://youtu.be/o7y7Y_Du6Oo?si=onMFIbphnAh6fR4j",
              },
              {
                "title": "Project idea",
                "url": "https://youtu.be/-Q4qkeG-GxQ?si=QopNAoh3LdI_je_o",
              },
            ];
          } else if (title == "Complete Firebase Explore") {
            videos = [
              {
                "title": "What is Firebase in Flutter?",
                "url": "https://youtu.be/kwqb-6QyYt8?si=VKkORqNbX7BycS-F",
              },
              {
                "title": "How to connect Android Studio",
                "url": "https://youtu.be/K1EKIeZNT2I?si=3ilRZoiHMZK51L7y",
              },
              {
                "title": "What is Firebase Database in Flutter? ",
                "url": "https://youtu.be/30_7x8uktHE?si=PdYyG6rhuxyY7-aL",
              },
              {
                "title": "Data Store",
                "url": "https://youtu.be/2dSxVKZItF4?si=GlqDzp7UY4qIIUae",
              },
              {
                "title": "Project",
                "url": "https://youtu.be/b8MmNxDM6fo?si=rf4f1bGg5eSEC33L",
              },
            ];
          } else {
            videos = [
              {
                "title": "Git & GitHub Introduction & Account Creation ",
                "url": "https://youtu.be/txsK4fqJbcc?si=fMt7pQyBbNZJ83Fu",
              },
              {
                "title": "How To Create Repositories In GitHub ",
                "url": "https://youtu.be/UUzX49Ft9G4?si=BQHdmaUz67EfMcvj",
              },
              {
                "title": "Git Pull & Push Git & Github",
                "url": "https://youtu.be/i_glB8n4KLE?si=lZspBVYU5iKeIj5C",
              },
              {
                "title": "Github Branch & Pull Request",
                "url": "https://youtu.be/inPYMFPdzRA?si=ePqIikTTKyW33sRj",
              },
              {
                "title": "Github Host a Website Free",
                "url": "https://youtu.be/CWimvvYWTd0?si=HTwEOew5-ePzu2af",
              },
            ];
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsPage(videos: videos),
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: image.startsWith('http')
                    ? Image.network(
                        image,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        image,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 5),
                        Text(rating),
                        const Spacer(),
                        const Icon(Icons.access_time, size: 18),
                        const SizedBox(width: 5),
                        Text(time),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetailsPage extends StatelessWidget {
  final List<Map<String, String>> videos;

  const CourseDetailsPage({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 35,
        ),
        title: const Text(
          "Course Videos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4169E1),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return videoItem(
            videos[index]["title"]!,
            videos[index]["url"]!,
          );
        },
      ),
    );
  }

  Widget videoItem(String title, String url) {
    return Link(
      uri: Uri.parse(url),
      target: LinkTarget.blank,
      builder: (context, followLink) {
        return GestureDetector(
          onTap: followLink,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ],
            ),

            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.blue,
                  size: 40,
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.indigo
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}