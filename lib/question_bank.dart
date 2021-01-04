import 'package:quiz_app/question.dart';
import 'opentdb_api.dart';

class QuestionBank {
  QuestionBank() {
    fetchData();
  }

  OpenTDBAPI api = new OpenTDBAPI();

  int _questionCursor = 0;

  List<Question> _questions = new List();

  Future<void> reset() async {
    _questionCursor = 0;
    _questions.clear();
    await fetchData();
  }

  bool atEnd() {
    return _questionCursor + 1 == _questions.length;
  }

  void nextQuestion() {
    if (_questionCursor < _questions.length - 1) _questionCursor++;
  }

  String getQuestionText() {
    return _questions.isNotEmpty ? _questions[_questionCursor].question : "";
  }

  bool getQuestionAnswer() {
    return _questions.isNotEmpty ? _questions[_questionCursor].answer : false;
  }

  int getAmountOfQuestions() {
    return _questions.length;
  }

  Future<void> fetchData() async {
    _questions = await api.getQuestions();
  }

  List<Question> getQuestionList() {
    return _questions;
  }
}
