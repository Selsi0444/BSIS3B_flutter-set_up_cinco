import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFFC0CB),
          primary: Color(0xFFFFC0CB),
        ),
      ),
      home: const QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//Start of quiz app
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  bool _quizStarted = false;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answerSelected = false;
  int? _selectedAnswerIndex;
  bool _quizEnded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        centerTitle: true,
        backgroundColor: Color(0xFFE75480),
        foregroundColor: Colors.white,
      ),
      body: !_quizStarted
          ? _buildStartView() // Show Start Screen
          : _quizEnded
              ? _buildEndView() // Show End Screen
              : _buildQuizView(), // Show Quiz Screen
    );
  }

  //Start view
  Widget _buildStartView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon
            const Icon(
              Icons.quiz,
              size: 100,
              color: Color(0xFFFF69B4),
            ),
            const SizedBox(height: 30),

            // MIDDLE: Title
            Text(
              'Quiz App',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE75480),
              ),
            ),
            const SizedBox(height: 20),

            // MIDDLE: Subtitle
            Text(
              'Test your Flutter knowledge!',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFFF66CC),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            // BOTTOM: Start Button
            ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Color(0xFFFF1493),
                foregroundColor: Colors.white,
              ),
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  // Action: Start Quiz Button
  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _currentQuestionIndex = 0;
      _score = 0;
      _answerSelected = false;
      _selectedAnswerIndex = null;
      _quizEnded = false;
    });
  }

  //Quiz View
  Widget _buildQuizView() {
    final question = _questions[_currentQuestionIndex];
    final answers = question['answers'] as List<String>;
    final correctAnswer = question['correctAnswer'] as int;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TOP: Progress Bar (Question number and Score)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE75480),
                ),
              ),
              Text(
                'Score: $_score',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF69B4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // MIDDLE-TOP: Question Card
          Card(
            elevation: 4,
            color: Color(0xFFFFB6C1),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                question['question'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // MIDDLE: Answer Buttons (4 buttons)
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final isCorrect = index == correctAnswer;
                final isSelected = _selectedAnswerIndex == index;

                Color? buttonColor;
                if (_answerSelected) {
                  if (isSelected) {
                    buttonColor = isCorrect ? Colors.green : Colors.red;
                  } else if (isCorrect) {
                    buttonColor = Colors.green.shade100;
                  }
                } else {
                  buttonColor = Color(0xFFFF66CC);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                    onPressed:
                        _answerSelected ? null : () => _selectAnswer(index),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: buttonColor,
                      disabledBackgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      answers[index],
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),

          // BOTTOM: Next Button (appears after answer selected)
          if (_answerSelected)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Color(0xFFE75480),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Action: Select Answer Button
  void _selectAnswer(int answerIndex) {
    if (_answerSelected) return; // Prevent multiple selections

    setState(() {
      _selectedAnswerIndex = answerIndex;
      _answerSelected = true;

      // Check if answer is correct
      if (answerIndex == _questions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
    });
  }

  // Action: Next Button
  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _answerSelected = false;
        _selectedAnswerIndex = null;
      } else {
        _quizEnded = true;
      }
    });
  }

  //Question & Answer
  final List<Map<String, dynamic>> _questions = [
    {
      'question':
          'Which feature would help Jollibee Cubao in Quezon City the most during peak hours?',
      'answers': [
        'Queue number system for walk-in customers',
        'Pre-order and pickup scheduling',
        'Real-time waiting time display',
        'Table reservation system',
      ],
      'correctAnswer': 0, // Index of correct answer (Queue number system)
    },
    {
      'question': 'What is the primary purpose of setState() in Flutter?',
      'answers': [
        'To update the UI when data changes',
        'To create a new widget',
        'To navigate to another screen',
        'To save data permanently',
      ],
      'correctAnswer': 0,
    },
    {
      'question': 'Which widget is used to create a scrollable list in Flutter?',
      'answers': [
        'Container',
        'Column',
        'ListView',
        'Stack',
      ],
      'correctAnswer': 2,
    },
  ];



  //End View
  Widget _buildEndView() {
    final percentage = (_score / _questions.length * 100).toStringAsFixed(0);
    final passed = _score >= (_questions.length / 2);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TOP: Trophy Icon (or Sad Face)
            Icon(
              passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 100,
              color: passed ? Color(0xFFFF69B4) : Color(0xFFFFB6C1),
            ),
            const SizedBox(height: 30),

            // UPPER-MIDDLE: Congratulations Text
            Text(
              passed ? 'Congratulations!' : 'Good Try!',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE75480),
              ),
            ),
            const SizedBox(height: 20),

            // MIDDLE: "Your Score" Label
            Text(
              'Your Score',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFFFF66CC),
              ),
            ),
            const SizedBox(height: 10),

            // MIDDLE: Score Number (3/3)
            Text(
              '$_score / ${_questions.length}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: passed ? Color(0xFFFF1493) : Color(0xFFFF69B4),
              ),
            ),
            const SizedBox(height: 10),

            // MIDDLE: Percentage (100%)
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFFFFB6C1),
              ),
            ),
            const SizedBox(height: 50),

            // BOTTOM: Restart Button
            ElevatedButton(
              onPressed: _restartQuiz,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Color(0xFFE75480),
                foregroundColor: Colors.white,
              ),
              child: const Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  // Action: Restart Button
  void _restartQuiz() {
    setState(() {
      _quizStarted = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _answerSelected = false;
      _selectedAnswerIndex = null;
      _quizEnded = false;
    });
  }
}
