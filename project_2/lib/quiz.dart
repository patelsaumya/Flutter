import 'package:flutter/material.dart';
import 'package:project_2/data/questions.dart';
import 'package:project_2/questions_screen.dart';
import 'package:project_2/results_screen.dart';
import 'package:project_2/start_screen.dart';


class Quiz extends StatefulWidget  {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  // Widget? activeScreen;

  // @override
  // void initState() {
  //   super.initState();
  //   activeScreen = StartScreen(switchScreen);
  // }

  List<String> selectedAnswers = [];
  var activeScreen = 'start-screen';

  void switchScreen() {
    setState(() {
      // activeScreen = const QuestionsScreen();
      activeScreen = 'questions-screen';
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    if (selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = 'results-screen';
      });
    }
  }

  void restartQuiz() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'questions-screen';
    });
  }

  @override
  Widget build(context) {
    // final screenWidget = activeScreen == 'start-screen'
    //     ? StartScreen(switchScreen)
    //     : const QuestionsScreen();

    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: chooseAnswer
      );
    } else if (activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(
        chosenAnswers: selectedAnswers,
        onRestart: restartQuiz
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            )
          ),
          // child: activeScreen
          child: screenWidget
        )
      )
    );
  }
}