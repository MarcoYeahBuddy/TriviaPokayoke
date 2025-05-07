import '../../models/trivia_model.dart';

class TriviaController {
  final List<TriviaQuestion> questions;
  int currentIndex = 0;

  TriviaController(this.questions);

  bool isCorrect(int selectedIndex) {
    return questions[currentIndex].correctIndex == selectedIndex;
  }

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
    }
  }

  bool isLastQuestion() {
    return currentIndex >= questions.length - 1;
  }

  int getScore() {
    int score = 0;
    for (int i = 0; i <= currentIndex; i++) {
      if (questions[i].correctIndex == questions[i].selectedIndex) {
        score++;
      }
    }
    return score;
  }
}
