import 'dart:async';

import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:quiz/Models/QuizModel.dart';
import 'package:quiz/Pages/Summary.dart';
import 'package:quiz/Models/AnsModel.dart';
import 'package:quiz/Provider/db_provider.dart';

class Quiz extends StatefulWidget {
  final int num_quiz;

  const Quiz({Key? key, required this.num_quiz}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  static const countdownDuration = Duration(minutes: 15);
  Duration duration = const Duration();
  Timer? timer;
  bool start = false; //กดเริ่มตอบคำถาม
  String asset_data = '';

  int no_quiz = 0;

  final int num_quiz = 15;
  List<int> sel_Choice = []; //คำตอบที่เลือก
  List<QuizModel> Quiz_List = []; //คำถาม
  List<String> Choice_List = []; //ตัวเลือกของคำถาม

  int num_correct = 0; // จำนวนที่ตอบถูก
  int num_incorrect = 0; // จำนวนที่ตอบผิด
  double percent = 0;
  String grade = 'F';
  Duration exam_duration = const Duration();

  // เมื่อกดปุ่มเริ่มตอบคำถาม
  void Start_Quiz() {
    setState(() {
      start = true;
      starttimer();
    });
  }

  // แสดงคำถามข้อถัดไป
  void Next_Question(id) {
    setState(() {
      no_quiz = id;
    });
  }

  // นับเวลาถอยหลัง
  void starttimer() {
    duration = countdownDuration;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (start) {
        setState(() {
          final seconds = duration.inSeconds - 1;

          if (seconds < 0) {
            timer?.cancel();
            check_Answer();
          } else {
            duration = Duration(seconds: seconds);
          }
        });
      }
    });
  }

  // สร้าง widget แสดงเวลาที่เหลือออกมา
  buildTime(Duration duration) {
    String twodigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twodigits(duration.inMinutes.remainder(60));
    final seconds = twodigits(duration.inSeconds.remainder(60));

    return '$minutes:$seconds';
  }

  // ตรวจคำตอบเมื่อกดส่งคำตอบ
  void check_Answer() {
    for (int i = 0; i < num_quiz; i++) {
      if (Quiz_List[i].answerId == sel_Choice[i]) {
        num_correct++;
      } else {
        num_incorrect++;
      }
    }

    percent = num_correct * 100 / num_quiz; //คำนวณเปอร์เซ็น

    // คำนวณเกรด
    if (percent >= 80) {
      grade = "A";
    } else if (percent >= 75) {
      grade = "B+";
    } else if (percent >= 70) {
      grade = "B";
    } else if (percent >= 65) {
      grade = "C+";
    } else if (percent >= 60) {
      grade = "C";
    } else if (percent >= 55) {
      grade = "D+";
    } else if (percent >= 50) {
      grade = "D";
    }

    exam_duration = countdownDuration - duration; //คำนวณเวลาที่ใช้

    print("ถูก $num_correct");
    print("ผิด $num_incorrect");
    print("เปอร์เซ็น $percent%");
    print("เวลาทั้งหมด $countdownDuration");
    print("เวลาที่เหลือ $duration");
    print("เกรด $grade");
    print("เวลาที่ทำ $exam_duration");

    Ans data = Ans(
        numQuiz: widget.num_quiz,
        timeStamp: DateTime.now().toString().substring(0, 19),
        numCorrect: num_correct,
        numIncorrect: num_incorrect,
        percent: percent.toStringAsFixed(2).toString(),
        grade: grade,
        examDuration: buildTime(exam_duration));

    DBProvider.instance.add(data);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Summary(num_quiz: widget.num_quiz, data: data),
        ),
        (route) => false);
  }

  // อ่านข้อมูลคำถาม
  readJson() async {
    if (widget.num_quiz == 1) {
      asset_data = 'assets/quiz/1.json';
    } else if (widget.num_quiz == 2) {
      asset_data = 'assets/quiz/2.json';
    } else if (widget.num_quiz == 3) {
      asset_data = 'assets/quiz/3.json';
    }

    final String response = await DefaultAssetBundle.of(context)
        .loadString(asset_data, cache: false);
    setState(() {
      Quiz_List = quizModelFromJson(response);
    });

    random_choice();
  }

  // สุ่มคำถามและตัวเลือก
  random_choice() {
    // สุ่มข้อ
    Quiz_List.shuffle();

    for (int i = 0; i < Quiz_List.length; i++) {
      // สุ่มตัวเลือก
      Quiz_List[i].choice.shuffle();

      // สร้างคำตอบตามตัวเลือก
      sel_Choice.add(0);
    }
  }

  @override
  void initState() {
    super.initState();
    readJson();
    duration = countdownDuration;
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ชุดที่ ${widget.num_quiz}'),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.alarm),
            onPressed: () {},
            label: Text(buildTime(duration)),
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              shadowColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: start
          ? sel_Choice.isEmpty || Quiz_List.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: 1,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Quiz_List[no_quiz].image != ""
                                    ? Image.asset(
                                        'assets/images/${Quiz_List[no_quiz].image}',
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Text(""),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${no_quiz + 1}. ${Quiz_List[no_quiz].title}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: Quiz_List[no_quiz].choice.length,
                                itemBuilder: (context, no_choice) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: Radio(
                                          value: int.parse(Quiz_List[no_quiz]
                                              .choice[no_choice]
                                              .id
                                              .toString()),
                                          groupValue: sel_Choice[no_quiz],
                                          onChanged: (int? value) {
                                            setState(() {
                                              sel_Choice[no_quiz] = value!;
                                            });
                                          },
                                        ),
                                        title: Text(
                                            '${Quiz_List[no_quiz].choice[no_choice].title}'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ),
                    Center(
                      child: NumberPaginator(
                        numberPages: num_quiz,
                        height: 48,
                        onPageChange: (int id) {
                          Next_Question(id);
                        },
                      ),
                    ),
                  ],
                )
          : Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                ),
                onPressed: () {
                  Start_Quiz();
                },
                child: const Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
      floatingActionButton: no_quiz == num_quiz - 1
          ? FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 0, 143, 19),
              hoverColor: Colors.amber,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('ต้องการส่งคำตอบของคุณหรือไม่'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('ยกเลิก'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            check_Answer();
                          },
                          child: const Text('ส่งคำตอบ'),
                        ),
                      ],
                    );
                  },
                );
              },
              tooltip: "ส่งคำตอบ",
              child: const Icon(Icons.send),
            )
          : const Center(),
    );
  }
}
