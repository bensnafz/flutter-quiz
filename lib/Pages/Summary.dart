import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quiz/Models/AnsModel.dart';
import 'package:quiz/Provider/db_provider.dart';

class Summary extends StatefulWidget {
  final int num_quiz;
  final Ans data;
  const Summary(
      {Key? key, required, required this.num_quiz, required Ans this.data})
      : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: Text('ชุดที่ ${widget.num_quiz}'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Center(
              child: CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 20.0,
                animation: true,
                percent: double.parse(widget.data.percent) / 100,
                center: Text(
                  widget.data.grade,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 50.0),
                ),
                footer: const Text(
                  "คะแนนที่ทำได้",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: const Color.fromARGB(255, 10, 8, 160),
              ),
            ),
            SizedBox(
              height: 50,
              child: Table(
                border: TableBorder.all(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: [
                      Column(
                        children: const [
                          Text(
                            'วันที่',
                            style: TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                              widget.data.timeStamp.toString().substring(0, 19),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Column(
                        children: const [
                          Text(
                            'จำนวนข้อที่ถูก',
                            style: TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.data.numCorrect.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Column(
                        children: const [
                          Text(
                            'จำนวนข้อที่ผิด',
                            style: TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.data.numIncorrect.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Column(
                        children: const [
                          Text(
                            'เปอร์เซ็นต์',
                            style: TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            double.parse(widget.data.percent)
                                    .toStringAsFixed(2) +
                                '%',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TableRow(
                    children: <Widget>[
                      Column(
                        children: const [
                          Text(
                            'เวลาที่ทำ',
                            style: TextStyle(fontSize: 20.0),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.data.examDuration,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(50),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/summary_all');
                },
                child: const Text("ดูสรุปผลรวม"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
