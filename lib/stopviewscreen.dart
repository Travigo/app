import 'package:flutter/material.dart';
import 'package:travigo/stop.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class DepartureBoard {
  String? destinationDisplay;
  String? time;
  String? type;

  DepartureBoard(
      {this.destinationDisplay,
      this.time,
      this.type});

  DepartureBoard.fromJson(Map<String, dynamic> json) {
    destinationDisplay = json['DestinationDisplay'];
    time = json['Time'];
    type = json['Type'];
  }
}

class StopViewScreen extends StatefulWidget {
  const StopViewScreen({super.key, required this.stop});

  final Stop stop;

  @override
  State<StopViewScreen> createState() => _StopViewScreenState(stop);
}

class _StopViewScreenState extends State<StopViewScreen> {
  _StopViewScreenState(this.stop);
  late Future<List<DepartureBoard>> futureDepartureBoards;

  final Stop stop;

  @override
  void initState() {
    super.initState();
    futureDepartureBoards = fetchStopDepartures(stop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stop.primaryName!),
      ),
      body: FutureBuilder<List<DepartureBoard>>(
        future: futureDepartureBoards,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DepartureBoard departure = snapshot.data![index];

                return ListTile(
                  // leading: stop.getIcon(),
                  title: Text(departure.destinationDisplay!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text("${departure.time!} ${departure.type!}", style: const TextStyle(fontSize: 12)),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
      // body: Center(
      //   child: FutureBuilder<List<DepartureBoard>>(
      //     future: futureDepartureBoards,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return Column(children: [ for (var departure in snapshot.data!) Card(
      //           child: ListTile(
      //             // leading: stop.getIcon(),
      //             title: Text(departure.destinationDisplay!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      //             subtitle: Text("${departure.time} ${departure.type}", style: const TextStyle(fontSize: 12)),
      //           ),
      //         ) ]);
      //       } else if (snapshot.hasError) {
      //         return Text('${snapshot.error}');
      //       }

      //       // By default, show a loading spinner.
      //       return const CircularProgressIndicator();
      //     },
      //   ),
      // ),
    );
  }
}
Future<List<DepartureBoard>> fetchStopDepartures(Stop stop) async {
  final response = await http
      .get(Uri.parse("https://api.travigo.app/core/stops/${stop.primaryIdentifier}/departures?count=25"));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable l = json.decode(response.body);
    return List<DepartureBoard>.from(l.map((model)=> DepartureBoard.fromJson(model)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load DepartureBoards');
  }
}