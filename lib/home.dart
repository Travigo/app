import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// class Stop {
//   final String primaryIdentifier;
//   final String primaryName;

//   const Stop({
//     required this.primaryIdentifier,
//     required this.primaryName,
//   });

//   factory Stop.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {
//         'PrimaryIdentifier': String primaryIdentifier,
//         'PrimaryName': String primaryName,
//       } =>
//         Stop(
//           primaryIdentifier: primaryIdentifier,
//           primaryName: primaryName
//         ),
//       _ => throw const FormatException('Failed to load stop.'),
//     };
//   }
// }
class Stop {
  String? primaryIdentifier;
  String? creationDateTime;
  String? modificationDateTime;
  String? primaryName;
  OtherNames? otherNames;
  List<String>? transportTypes;
  Location? location;

  Stop(
      {this.primaryIdentifier,
      this.creationDateTime,
      this.modificationDateTime,
      this.primaryName,
      this.otherNames,
      this.transportTypes,
      this.location});

  Stop.fromJson(Map<String, dynamic> json) {
    primaryIdentifier = json['PrimaryIdentifier'];
    creationDateTime = json['CreationDateTime'];
    modificationDateTime = json['ModificationDateTime'];
    primaryName = json['PrimaryName'];
    otherNames = json['OtherNames'] != null
        ? OtherNames.fromJson(json['OtherNames'])
        : null;
    transportTypes = json['TransportTypes'] == null ? [] : json['TransportTypes'].cast<String>();
    location = json['Location'] != null
        ? Location.fromJson(json['Location'])
        : null;
  }

  Icon getIcon() {
    if (transportTypes != null && transportTypes!.contains("Metro")) {
      return const Icon(Icons.directions_train_rounded);
    }

    if (transportTypes != null && transportTypes!.contains("Tram")) {
      return const Icon(Icons.tram_rounded);
    }

    if (transportTypes != null && transportTypes!.contains("Rail")) {
      return const Icon(Icons.train_rounded);
    }

    if (transportTypes != null && transportTypes!.contains("Ferry")) {
      return const Icon(Icons.directions_ferry_rounded);
    }

    if (transportTypes != null && transportTypes!.contains("CableCar")) {
      return const Icon(Icons.cable);
    }

    if (transportTypes != null && transportTypes!.contains("Coach")) {
      return const Icon(Icons.airport_shuttle_rounded);
    }

    if (transportTypes != null && transportTypes!.contains("Airport")) {
      return const Icon(Icons.local_airport_rounded);
    }
    

    // Just default to bus in the end
    return const Icon(Icons.directions_bus_sharp);
  }
}

class OtherNames {
  String? indicator;
  String? landmark;
  String? shortCommonName;
  String? street;

  OtherNames(
      {this.indicator, this.landmark, this.shortCommonName, this.street});

  OtherNames.fromJson(Map<String, dynamic> json) {
    indicator = json['Indicator'];
    landmark = json['Landmark'];
    shortCommonName = json['ShortCommonName'];
    street = json['Street'];
  }
}

class Location {
  List<double>? coordinates;

  Location({this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
  }
}
Future<List<Stop>> fetchStops() async {
  final response = await http
      .get(Uri.parse('https://api.travigo.app/core/stops/?bounds=-0.12715893421443525,51.52952181181732,-0.11971803320432173,51.53347616323964'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable l = json.decode(response.body);
    return List<Stop>.from(l.map((model)=> Stop.fromJson(model)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load stops');
  }
}




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
              // const Card(
              //   child: ListTile(
              //     leading: Icon(Icons.directions_bus_sharp),
              //     title: Text('Railway Station', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              //     subtitle: Text('Stop 6 Railway Station', style: TextStyle(fontSize: 12)),
              //   ),
              // ),
              Center(
                child: FutureBuilder<List<Stop>>(
                  future: futureStops,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // return Text(snapshot.data![0].primaryIdentifier);
                      // return ListView.builder(
                      //   itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     Stop stop = snapshot.data![index];
                      //     return Card(
                      //       child: Text(stop.primaryIdentifier),
                      //     );
                      //   },
                      // );

                      return Column(children: [ for (var stop in snapshot.data!) Card(
                        child: ListTile(
                          leading: stop.getIcon(),
                          title: Text(stop.primaryName!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text("${stop.otherNames?.indicator} ${stop.otherNames?.landmark}", style: const TextStyle(fontSize: 12)),
                        ),
                      ) ]);
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
