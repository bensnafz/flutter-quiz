import 'package:flutter/material.dart';
import 'package:quiz/Pages/About.dart';
import 'package:quiz/Pages/Quiz.dart';
import 'package:quiz/Pages/SummaryAll.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color.fromARGB(255, 252, 239, 239)),
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   primaryColor: MyStyle.secondColor,
      //   fontFamily: 'Roboto',
      // ),
      // theme: darkThemeData(context),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/summary_all': (context) => const SummaryAll(),
        '/about': (context) => const About(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Movie Quiz",
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueAccent,
            ),
          ),
          const Text(
            "Marvel Cinematic Universe",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              backgroundColor: Colors.red,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
          ),
          Center(
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/avengers-marvel.jpg'),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: Stack(
                children: const <Widget>[
                  Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text(
                      "Menu",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: const <Widget>[
                        Icon(Icons.pages),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('ข้อสอบชุดที่ 1'),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Quiz(
                            num_quiz: 1,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const <Widget>[
                        Icon(Icons.pages),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('ข้อสอบชุดที่ 2'),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Quiz(
                            num_quiz: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const <Widget>[
                        Icon(Icons.pages),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('ข้อสอบชุดที่ 3'),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Quiz(
                            num_quiz: 3,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const <Widget>[
                        Icon(Icons.wysiwyg),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('ผลสรุป'),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/summary_all');
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                title: Row(
                  children: const <Widget>[
                    Icon(Icons.help_outline),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('เกี่ยวกับ'),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
