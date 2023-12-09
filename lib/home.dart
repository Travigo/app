import 'package:flutter/material.dart';
import 'package:travigo/stop.dart';
import 'dart:async';

import 'package:travigo/stopviewscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  late Future<List<Stop>> futureStops;

  @override
  void initState() {
    super.initState();
    futureStops = fetchStops();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        flexibleSpace: Container(
          margin: EdgeInsets.only(
            left: 4.0,
            right: 4.0,
            top: MediaQuery.of(context).viewPadding.top,
            bottom: 0
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
            border: Border.all(color: const Color.fromARGB(255, 224, 224, 224)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 223, 222, 222),
                spreadRadius: 0,
                blurRadius: 1,
                offset: Offset(0, 2), // changes position of shadow
              )
            ]
          ),
          // color: Colors.white,
          // child: const Column(
          //   children: [
          //     Text('One'),
          //     Text('Two'),
          //     Text('Three'),
          //     Text('Four'),
          //   ],
          // ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              const Text(
                "Nearby Stops", 
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
              ),
              Center(
                child: FutureBuilder<List<Stop>>(
                  future: futureStops,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(children: [ for (var stop in snapshot.data!) 
                        Card(
                          elevation: 0.3,
                          child: ListTile(
                            dense: true,
                            leading: stop.getIcon(),
                            title: Text(stop.primaryName!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Text("${stop.otherNames?.indicator} ${stop.otherNames?.landmark}", style: const TextStyle(fontSize: 12)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StopViewScreen(stop: stop)),
                              );
                            },
                          ),
                        ) 
                      ]);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
