import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExamsPage(),
    );
  }
}

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,toolbarHeight: 250,
        title: const Text(
          "Quizzes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          quizCard(
            context,
            "Flutter Basics Quiz",
            "Test your knowledge of Flutter fundamentals",
            "10 Questions",
            "30 minutes",
          ),
          quizCard(
            context,
            "Dart Programming Quiz",
            "Check your understanding of Dart concepts",
            "10 Questions",
            "25 minutes",
          ),
          quizCard(
            context,
            "State Management Quiz",
            "Test your knowledge of State Management",
            "10 Questions",
            "20 minutes",
          ),
        ],
      ),
    );
  }

  Widget quizCard(
    BuildContext context,
    String title,
    String subtitle,
    String questions,
    String time,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizPage(title: title)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4169E1),
              ),
            ),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.help_outline, size: 18),
                    const SizedBox(width: 5),
                    Text(questions),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 5),
                    Text(time),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String title;
  const QuizPage({super.key, required this.title});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int timeLeft = 180;
  Timer? timer;
  int currentQuestion = 0;
  int score = 0;
  int? selectedOption;
  late List<Map<String, Object>> questions;

  @override
  void initState() {
    super.initState();
    if (widget.title == "Flutter Basics Quiz") {
      questions = flutterQuestions;
    } else if (widget.title == "Dart Programming Quiz") {
      questions = dartQuestions;
    } else {
      questions = stateQuestions;
    }
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        t.cancel();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultPage(score: score)),
        );
      }
    });
  }

  void nextQuestion() {
    if (selectedOption == questions[currentQuestion]["correct"]) {
      score++;
    }
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedOption = null;
      });
    } else {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(score: score)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var q = questions[currentQuestion];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF4169E1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Question ${currentQuestion + 1} of ${questions.length}",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        "Time: ${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    q["question"] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...((q["answers"] as List<String>).asMap().entries.map(
              (e) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedOption == e.key
                        ? const Color(0xFF4169E1)
                        : Colors.white,
                    foregroundColor: selectedOption == e.key
                        ? Colors.white
                        : const Color(0xFF4169E1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Color(0xFF4169E1)),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedOption = e.key;
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(e.value, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            )),
            const Spacer(),
            if (selectedOption != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: const Color(0xFF4169E1),
                  ),
                  child: Text(
                    currentQuestion == questions.length - 1 ? "Submit" : "Next",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  const ResultPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Result",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4169E1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events, // trophy icon
              size: 100,
              color: Colors.amber, // golden color
            ),

            const SizedBox(height: 30),

            const Text(
              "Quiz Completed 🎉",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Text(
              "Your Score",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),

            const SizedBox(height: 10),

            Text(
              "$score / 10",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4169E1),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4169E1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Back to Home",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, Object>> flutterQuestions = [
  {
    "question": "Flutter is developed by?",
    "answers": ["Facebook", "Google", "Microsoft", "Apple"],
    "correct": 1,
  },
  {
    "question": "Flutter uses which language?",
    "answers": ["Java", "Dart", "Swift", "Kotlin"],
    "correct": 1,
  },
  {
    "question": "Which widget is immutable?",
    "answers": ["StatefulWidget", "StatelessWidget", "Container", "Column"],
    "correct": 1,
  },
  {
    "question": "Hot reload is used for?",
    "answers": [
      "Restart app",
      "Update UI instantly",
      "Delete app",
      "Compile app",
    ],
    "correct": 1,
  },
  {
    "question": "Flutter apps compile to?",
    "answers": ["Native Code", "HTML", "Python", "Ruby"],
    "correct": 0,
  },
  {
    "question": "Which widget arranges children vertically?",
    "answers": ["Row", "Column", "Stack", "Align"],
    "correct": 1,
  },
  {
    "question": "Which company created Dart?",
    "answers": ["Google", "Apple", "Meta", "IBM"],
    "correct": 0,
  },
  {
    "question": "setState() is used in?",
    "answers": ["StatelessWidget", "StatefulWidget", "Both", "None"],
    "correct": 1,
  },
  {
    "question": "Flutter is mainly for?",
    "answers": ["Mobile", "Web", "Desktop", "All platforms"],
    "correct": 3,
  },
  {
    "question": "Which widget adds padding?",
    "answers": ["Padding", "Center", "Text", "Icon"],
    "correct": 0,
  },
];
List<Map<String, Object>> dartQuestions = [
  {
    "question": "Dart is a?",
    "answers": ["Language", "Framework", "Database", "IDE"],
    "correct": 0,
  },
  {
    "question": "Variable declare keyword?",
    "answers": ["var", "int", "String", "All"],
    "correct": 3,
  },
  {
    "question": "Dart supports?",
    "answers": ["OOP", "Functional", "Both", "None"],
    "correct": 2,
  },
  {
    "question": "Main function keyword?",
    "answers": ["start()", "main()", "run()", "init()"],
    "correct": 1,
  },
  {
    "question": "List is?",
    "answers": ["Collection", "Widget", "Class", "Function"],
    "correct": 0,
  },
  {
    "question": "String is?",
    "answers": ["Data type", "Function", "Widget", "Loop"],
    "correct": 0,
  },
  {
    "question": "Loop example?",
    "answers": ["for", "while", "do while", "All"],
    "correct": 3,
  },
  {
    "question": "Dart file extension?",
    "answers": [".dart", ".java", ".kt", ".py"],
    "correct": 0,
  },
  {
    "question": "Null safety introduced in?",
    "answers": ["Dart 1", "Dart 2", "Dart 3", "None"],
    "correct": 1,
  },
  {
    "question": "Print function?",
    "answers": ["echo()", "console()", "print()", "write()"],
    "correct": 2,
  },
];
List<Map<String, Object>> stateQuestions = [
  {
    "question": "State is?",
    "answers": ["Data", "UI", "Widget", "Theme"],
    "correct": 0,
  },
  {
    "question": "Which widget manages state?",
    "answers": ["StatelessWidget", "StatefulWidget", "Container", "Text"],
    "correct": 1,
  },
  {
    "question": "setState() does?",
    "answers": ["Refresh UI", "Delete UI", "Close app", "Restart phone"],
    "correct": 0,
  },
  {
    "question": "Provider is used for?",
    "answers": ["State Management", "Design", "Database", "API"],
    "correct": 0,
  },
  {
    "question": "State change triggers?",
    "answers": ["Rebuild", "Delete", "Crash", "Nothing"],
    "correct": 0,
  },
  {
    "question": "InitState runs?",
    "answers": ["Once", "Always", "Never", "Twice"],
    "correct": 0,
  },
  {
    "question": "Build method returns?",
    "answers": ["Widget", "Function", "Data", "List"],
    "correct": 0,
  },
  {
    "question": "Which is simple state management?",
    "answers": ["setState", "Bloc", "Redux", "Riverpod"],
    "correct": 0,
  },
  {
    "question": "Context used for?",
    "answers": ["Theme", "Navigation", "MediaQuery", "All"],
    "correct": 3,
  },
  {
    "question": "StatefulWidget has?",
    "answers": ["createState()", "build()", "run()", "start()"],
    "correct": 0,
  },
];
