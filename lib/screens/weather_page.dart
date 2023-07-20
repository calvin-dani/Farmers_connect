// weather_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WeatherCard extends StatefulWidget {
  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  String weatherData = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  void fetchWeatherData() async {
    try {
      final dynamic weatherResponse = await ApiService.fetchWeather();
      final Map<String, dynamic> weatherMap = weatherResponse
          as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>

      final String weatherInfo = weatherMap['weather'] ??
          'Weather data not available'; // Extract the weather information from the Map

      setState(() {
        weatherData = weatherInfo;
      });
    } catch (e) {
      // Handle the error
      print('Error fetching weather: $e');
      setState(() {
        weatherData = 'Failed to fetch weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WeatherPage(weatherData)),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/weather_icon.png',
                height: 80.0, width: 80.0),
            SizedBox(height: 8.0),
            Text('Weather', style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 8.0),
            Text(weatherData),
          ],
        ),
      ),
    );
  }
}

class WeatherPage extends StatelessWidget {
  final String weatherData;

  WeatherPage(this.weatherData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: Center(
        // Display the weather details received from WeatherCard
        child: Text(weatherData),
      ),
    );
  }
}
