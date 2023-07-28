import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/api_service.dart';

class WeatherCard extends StatefulWidget {
  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  dynamic weatherData = '';
  Position? _currentPosition;
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getLocation() async {
    final hasPermission = await _handleLocationPermission();
    try {
      if (!hasPermission) return;
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => _currentPosition = position);
        fetchWeatherData();
      }).catchError((e) {
        debugPrint(e);
      });
    } catch (e) {
      print(e);
    }
  }

  void fetchWeatherData() async {
    try {
      final dynamic weatherResponse =
          await ApiService.fetchWeather(_currentPosition);
      final dynamic weatherMap =
          weatherResponse; // Explicitly cast to Map<String, dynamic>

      final List<dynamic> weatherInfo = weatherMap['weather'] ??
          [
            'Weather data not available'
          ]; // Extract the weather information from the Map

      setState(() {
        weatherData = weatherMap;
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
        color: Colors.green, // Change the background color of the card to green
        child: Padding(
          padding: EdgeInsets.all(16.0), // Add padding to the Card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny,
                  size: 80,
                  color: Colors.white), // Change the color of the icon to white
              SizedBox(height: 8.0),
              Text(
                'Weather',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white, // Change the color of the text to white
                  fontWeight: FontWeight.bold, // Make the font bold
                ),
              ),
              SizedBox(height: 8.0),
              // Text(weatherData),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherPage extends StatelessWidget {
  dynamic weatherData = {'id': 0, 'main': '', 'description': '', 'icon': ''};
  WeatherPage(this.weatherData);

  @override
  Widget build(BuildContext context) {
    print(weatherData);
    double tempCelsius = weatherData['main']["temp"];
    double tempFahrenheit = tempCelsius / 10 * 9 / 5 + 32;
    double windSpeedKmph = weatherData['wind']["speed"];
    double windSpeedMph = windSpeedKmph * 0.621371;
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.green[50],
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Text(
                  '${weatherData['name']}', // Location name here
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Weather Description: ${weatherData['weather'][0]["description"]}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Temperature: ${tempFahrenheit.toStringAsFixed(2)}°F',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Wind Speed: ${windSpeedMph.toStringAsFixed(2)} mph',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Humidity: ${weatherData['main']["humidity"].toString()}%',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Clouds: ${weatherData['clouds']["all"].toString()}%',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
