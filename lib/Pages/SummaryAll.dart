import 'package:flutter/material.dart';
import 'package:quiz/Models/AnsModel.dart';
import 'package:quiz/Provider/db_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SummaryAll extends StatefulWidget {
  const SummaryAll({Key? key}) : super(key: key);

  @override
  State<SummaryAll> createState() => _SummaryAllState();
}

class _SummaryAllState extends State<SummaryAll> {
  List<Ans> ans = [];
  List<Ans> ansAll = [];

  List<Ans> ansData = [];
  bool max = true;

  int _select = 0;

  _loadData() async {
    List<Ans> data = _select == 0
        ? await DBProvider.instance.getAns()
        : await DBProvider.instance.getAnsbyNumQuiz(_select);

    ansAll = await DBProvider.instance.getAnsData();

    ansData = max
        ? await DBProvider.instance.getAnsMax()
        : await DBProvider.instance.getAnsMin();
    setState(() {
      ans = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          title: const Text("สรุปผลภาพรวมทั้งหมด"),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "สถิติ",
              ),
              Tab(
                text: "ประวัติ",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Expanded(
              child: ans.isNotEmpty
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 255, 117, 54)),
                              onPressed: () {
                                _loadData();
                              },
                              child: const Text('ทั้งหมด'),
                            ),
                          ],
                        ),
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelRotation: 90,
                          ),
                          series: <ChartSeries>[
                            ColumnSeries<Ans, dynamic>(
                              dataSource: ansAll,
                              xValueMapper: (Ans ans, _) =>
                                  ans.timeStamp.toString(),
                              yValueMapper: (Ans ans, _) => ans.numCorrect,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: max
                                    ? const Color.fromARGB(255, 30, 223, 203)
                                    : Colors.teal,
                              ),
                              icon: const Icon(Icons.trending_up),
                              onPressed: () {
                                setState(() {
                                  max = true;
                                  _loadData();
                                });
                              },
                              label: const Text("มากที่สุด"),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: max == false
                                    ? const Color.fromARGB(255, 30, 223, 203)
                                    : Colors.teal,
                              ),
                              icon: const Icon(Icons.trending_down),
                              onPressed: () {
                                setState(() {
                                  max = false;
                                  _loadData();
                                });
                              },
                              label: const Text("น้อยที่สุด"),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: ansData.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ExpansionTile(
                                      subtitle: Text(
                                          '${ansData[index].percent.toString()}% เกรด ${ansData[index].grade.toString()}'),
                                      title: Text(
                                          '[ชุดที่ ${ansData[index].numQuiz}] ${ansData[index].timeStamp.toString()}'),
                                      children: [
                                        ListTile(
                                          title: const Text('ข้อถูก'),
                                          trailing: Text(ansData[index]
                                              .numCorrect
                                              .toString()),
                                        ),
                                        ListTile(
                                          title: const Text('ข้อผิด'),
                                          trailing: Text(ansData[index]
                                              .numIncorrect
                                              .toString()),
                                        ),
                                        ListTile(
                                          title: const Text('เวลาที่ใช้'),
                                          trailing: Text(ansData[index]
                                              .examDuration
                                              .toString()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Expanded(
              child: ansData.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: _select == 0
                                    ? const Color.fromARGB(255, 255, 117, 54)
                                    : const Color.fromARGB(255, 52, 19, 241),
                              ),
                              onPressed: () {
                                setState(() {
                                  _select = 0;
                                  _loadData();
                                });
                              },
                              child: const Text('ทั้งหมด'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: _select == 1
                                    ? const Color.fromARGB(255, 255, 117, 54)
                                    : const Color.fromARGB(255, 52, 19, 241),
                              ),
                              onPressed: () {
                                setState(() {
                                  _select = 1;
                                  _loadData();
                                });
                              },
                              child: const Text('ชุดที่ 1'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: _select == 2
                                    ? const Color.fromARGB(255, 255, 117, 54)
                                    : const Color.fromARGB(255, 52, 19, 241),
                              ),
                              onPressed: () {
                                setState(() {
                                  _select = 2;
                                _loadData();
                                });
                              },
                              child: const Text('ชุดที่ 2'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: _select == 3
                                    ? const Color.fromARGB(255, 255, 117, 54)
                                    : const Color.fromARGB(255, 52, 19, 241),
                              ),
                              onPressed: () {
                                setState(() {
                                  _select = 3;
                                _loadData();
                                });
                              },
                              child: const Text('ชุดที่ 3'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: ans.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ExpansionTile(
                                      subtitle: Text(
                                          '${ans[index].percent.toString()}% เกรด ${ans[index].grade.toString()}'),
                                      title: Text(
                                          '[ชุดที่ ${ans[index].numQuiz}] ${ans[index].timeStamp.toString()}'),
                                      children: [
                                        ListTile(
                                          title: const Text('ข้อถูก'),
                                          trailing: Text(
                                              ans[index].numCorrect.toString()),
                                        ),
                                        ListTile(
                                          title: const Text('ข้อผิด'),
                                          trailing: Text(ans[index]
                                              .numIncorrect
                                              .toString()),
                                        ),
                                        ListTile(
                                          title: const Text('เวลาที่ใช้'),
                                          trailing: Text(ans[index]
                                              .examDuration
                                              .toString()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              DBProvider.instance.removeAll();
                              _loadData();
                            });
                          },
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
