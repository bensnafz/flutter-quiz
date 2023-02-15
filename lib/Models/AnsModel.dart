// To parse this JSON data, do
//
//     final ans = ansFromJson(jsonString);

import 'dart:convert';

Ans ansFromJson(String str) => Ans.fromJson(json.decode(str));

String ansToJson(Ans data) => json.encode(data.toJson());

class Ans {
  Ans({
    this.id = 0,
    required this.numQuiz,
    required this.timeStamp,
    required this.numCorrect,
    required this.numIncorrect,
    required this.percent,
    required this.grade,
    required this.examDuration,
  });

  int id;
  int numQuiz;
  String timeStamp;
  int numCorrect;
  int numIncorrect;
  String percent;
  String grade;
  String examDuration;

  factory Ans.fromJson(Map<String, dynamic> json) => Ans(
        id: json["id"],
        numQuiz: json["num_quiz"],
        timeStamp: json["time_stamp"],
        numCorrect: json["num_correct"],
        numIncorrect: json["num_incorrect"],
        percent: json["percent"].toString(),
        grade: json["grade"],
        examDuration: json["exam_duration"],
      );

  Map<String, dynamic> toJson() => {
        "num_quiz": numQuiz,
        "time_stamp": timeStamp,
        "num_correct": numCorrect,
        "num_incorrect": numIncorrect,
        "percent": percent,
        "grade": grade,
        "exam_duration": examDuration,
      };
}
