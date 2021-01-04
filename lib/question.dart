import 'package:html_unescape/html_unescape.dart';

class Question {
  String question;
  bool answer;
  String category;
  String difficulty;

  Question.qAndA(String q, bool ans) {
    question = q;
    answer = ans;
  }

  Question({
    this.question,
    this.answer,
    this.category,
    this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var unescape = new HtmlUnescape();
    String a = json["correct_answer"];
    return Question(
      question: unescape.convert(json["question"]),
      answer: a.parseBool(),
      category: json["category"],
      difficulty: json["difficulty"],
    );
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase().trim() == 'true';
  }
}
