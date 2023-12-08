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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
