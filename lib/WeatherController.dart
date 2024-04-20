import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'WeatherModel.dart';
class WeatherController with ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  void fetchWeather(Position position) async {
    _isLoading = true;
    notifyListeners();
    final response = await http
        .get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat='
            '${position.latitude}&lon=${position.longitude}'
            '&appid=d21c6e56f8f604339ca76572b36c4fd7'));
    if (response.statusCode == 200) {
      _weather = Weather.fromJson(json.decode(response.body));
    } else {
      // handle errors
      throw Exception('Failed to load weather');
    }
    _isLoading = false;
    notifyListeners();
  }
}
