import 'package:flutter/material.dart';
import 'package:travigo/stop.dart';

class StopViewScreen extends StatelessWidget {
  const StopViewScreen({super.key, required this.stop});

  final Stop stop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stop.primaryName!),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}