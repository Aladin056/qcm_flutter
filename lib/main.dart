import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/quizmodel.dart';

Future<List<QuizModel>> loadQuizData() async {
  String jsonString = await rootBundle.loadString('assets/json/question.json');
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList
      .map((json) =>
          QuizModel(question: json['question'], answer: json['answer']))
      .toList();
}

// initialisation
void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _quserIndex = 0;
  int _score = 0;
  int _sco = 1;
  List<QuizModel> _quizQuestions = [];

  @override
  void initState() {
    super.initState();
    loadQuizData().then((quizData) {
      setState(() {
        _quizQuestions = quizData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('AlaDin Quiz App'),
        ),
        body: _quizQuestions.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'La Grèce antique',
                    style: TextStyle(fontSize: 30, color: Colors.lightGreen),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '$_sco /10 ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _quizQuestions[_quserIndex].question,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _checkAnswer(true);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Text(
                          'Vrai',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _checkAnswer(false);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: Text('Faux'),
                      ),
                    ],
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _checkAnswer(bool userAnswer) {
    if (_quizQuestions[_quserIndex].answer == userAnswer) {
      _score++;
    }
    setState(() {
      _quserIndex++;
      _sco++;
      if (_quserIndex >= _quizQuestions.length) {
        _showResultDialog();
        _quserIndex--;
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Result'),
          content:
              Text('Tu as $_score sur ${_quizQuestions.length} de correcte !'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _quserIndex = 0;
                  _score = 0;
                });
              },
              child: Text(''),
            ),
          ],
        );
      },
    );
  }
}
