class Weather {
  final double temperature ;
  final double windSpeed;
  final int humidity;
  final String country;

  Weather({required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.country});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'],
      windSpeed: json['wind']['speed'],
      humidity: json['main']['humidity'],
      country: json['sys']['country'],
    );
  }
}




