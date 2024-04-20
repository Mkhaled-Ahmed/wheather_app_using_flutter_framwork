import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'WeatherController.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Consumer<WeatherController>(
              builder: (context, weatherController, child) {
                if (weatherController.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (weatherController.weather != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          "Temperature: ${weatherController.weather?.temperature}°F"),
                      Text(
                          "Wind Speed: ${weatherController.weather?.windSpeed} m/s"),
                      Text("Humidity: ${weatherController.weather?.humidity}%"),
                      Text("Country: ${weatherController.weather?.country}"),
                    ],
                  );
                } else {
                  return Center(
                      child: Text("Press the button to fetch weather"));
                }
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder<Position>(
              future: _determinePosition(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        "Map will be displayed here\nLat: ${snapshot.data!.latitude}, Lng: ${snapshot.data!.longitude}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text("Unable to fetch location"));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Provider.of<WeatherController>(context, listen: false)
              .fetchWeather(await _determinePosition());
        },
        tooltip: 'Fetch Weather',
        child: const Icon(Icons.cloud),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
