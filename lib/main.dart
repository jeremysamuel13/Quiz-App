import 'package:quiz_app/question_bank.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(QuizApp());
QuestionBank questionBank = QuestionBank();

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> score = [];
  int correct = 0;
  int incorrect = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDataHelper();
  }

  Future<void> fetchDataHelper() async {
    setState(() {
      loading = true;
    });
    await questionBank.fetchData().then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  questionBank.getQuestionText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text(
                  'True',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  checkAnswer(true);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                color: Colors.red,
                child: Text(
                  'False',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  checkAnswer(false);
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: score,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Questions powered by opentdb.com",
                style: TextStyle(
                  color: Colors.white12,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 5,
            ),
            FutureBuilder(
              future: Future.delayed(const Duration(seconds: 7)),
              builder: (c, s) {
                double _visible = 0.0;
                if (s.connectionState == ConnectionState.done) {
                  _visible = 1.0;
                } else {
                  _visible = 0.0;
                }

                return AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  child: AnimatedOpacity(
                    opacity: _visible,
                    duration: Duration(seconds: 1),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Is this taking too long? Check your internet connection",
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }

  void checkAnswer(bool choice) {
    setState(() {
      if (choice == questionBank.getQuestionAnswer()) {
        score.add(Icon(
          Icons.check,
          color: Colors.green,
        ));
        correct++;
      } else {
        score.add(Icon(
          Icons.close,
          color: Colors.red,
        ));
        incorrect++;
      }

      if (questionBank.atEnd()) {
        _resetGame(context);
      }

      questionBank.nextQuestion();
    });
  }

  void _resetGame(BuildContext context) {
    int total = questionBank.getAmountOfQuestions();
    double percent = (correct / total) * 100;
    var a = Alert(
        context: context,
        title: "$percent%",
        desc: "You got $correct out of $total questions right.",
        buttons: [
          DialogButton(
            color: Colors.black,
            child: Text(
              "Reset Quiz",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onPressed: (() {
              Navigator.pop(context);
              setState(() {
                questionBank.reset();
                fetchDataHelper();
                score.clear();
                correct = 0;
                incorrect = 0;
                percent = 0;
              });
            }),
          )
        ],
        style: new AlertStyle(
          backgroundColor: Colors.white,
          animationType: AnimationType.fromTop,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.grey.shade900),
          ),
        ));
    a.show();
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
