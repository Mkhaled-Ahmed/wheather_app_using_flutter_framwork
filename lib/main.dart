import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/WeatherController.dart';

import 'WeatherScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherController()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        home: WeatherScreen(),
      ),
    );
  }
}

