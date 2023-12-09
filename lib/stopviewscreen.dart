import 'package:flutter/material.dart';
import 'package:travigo/hexcolor.dart';
import 'package:travigo/journey.dart';
import 'package:travigo/stop.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DepartureBoard {
  String? destinationDisplay;
  String? time;
  String? type;
  String? platform;
  String? platformType;
  Journey? journey;

  DepartureBoard(
      {this.destinationDisplay,
      this.time,
      this.type,
      this.platform,
      this.platformType,
      this.journey});

  DepartureBoard.fromJson(Map<String, dynamic> json) {
    destinationDisplay = json['DestinationDisplay'];
    time = json['Time'];
    type = json['Type'];
    platform = json['Platform'];
    platformType = json['PlatformType'];
    journey = json['Journey'] != null
        ? Journey.fromJson(json['Journey'])
        : null;
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

                DateTime departureTime = DateTime.parse(departure.time!);

                Text departureTypeText;
                switch (departure.type) {
                  case "RealtimeTracked":
                    departureTypeText = const Text("Realtime", style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 1, 181, 49)));
                  case "Estimated":
                    departureTypeText = const Text("Estimated", style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 196, 139, 4)));
                  case "Cancelled":
                    departureTypeText = const Text("CANCELLED", style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 201, 11, 11)));
                  default:
                    departureTypeText = Text(departure.type!, style: const TextStyle(fontSize: 12));
                }

                String platformText = "";

                if (departure.platform != "") {
                  if (departure.platformType == "ESTIMATED") {
                    platformText = "Platform ${departure.platform} (Estimated)";
                  } else {
                    platformText = "Platform ${departure.platform}";
                  }
                }

                Widget serviceWidget;

                if (departure.journey!.service.brandIcon != "") {
                  serviceWidget = Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Image(
                        image: NetworkImage("https://travigo.app${departure.journey!.service.brandIcon}"),
                      )
                  );
                } else {
                  serviceWidget = Text(departure.journey!.service.serviceName);
                }

                return Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: HexColor.fromHex(departure.journey!.service.brandColour),
                      ),
                      child: Center(child: serviceWidget)
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(departure.destinationDisplay!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          Text(departure.journey == null ? "Unknown Operator" : departure.journey!.journeyOperator.primaryName)
                        ]
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(DateFormat('HH:mm').format(departureTime), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          departureTypeText,
                          Text(platformText, style: const TextStyle(fontSize: 12))
                        ],
                      )
                    )
                  ]
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