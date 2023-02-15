import 'dart:convert';

List<QuizModel> quizModelFromJson(String str) =>
    List<QuizModel>.from(json.decode(str).map((x) => QuizModel.fromJson(x)));

String quizModelToJson(List<QuizModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuizModel {
  QuizModel({
    required this.title,
    required this.image,
    required this.choice,
    required this.answerId,
  });

  dynamic title;
  dynamic image;
  List<Choice> choice;
  dynamic answerId;

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        title: json["title"],
        image: json["image"],
        choice:
            List<Choice>.from(json["choice"].map((x) => Choice.fromJson(x))),
        answerId: json["answerID"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "choice": List<dynamic>.from(choice.map((x) => x.toJson())),
        "answerID": answerId,
      };
}

class Choice {
  Choice({
    required this.id,
    required this.title,
  });

  dynamic id;
  dynamic title;

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
