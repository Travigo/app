import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

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