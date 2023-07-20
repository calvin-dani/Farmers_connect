// weather_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:geolocator/geolocator.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/weather_icon.png',
                height: 80.0, width: 80.0),
            SizedBox(height: 8.0),
            Text('Weather', style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 8.0),
            // Text(weatherData),
          ],
        ),
      ),
    );
  }
}

class WeatherPage extends StatelessWidget {
  dynamic weatherData = {'id': 0, 'main': '', 'description': '', 'icon': ''};
  List<String> OptionsAPI = [
    'Weather',
    'Temperature',
    'Wind',
    'Rain',
    'Clouds'
  ];
  WeatherPage(this.weatherData);

  @override
  Widget build(BuildContext context) {
    print(weatherData);
    return Scaffold(
        appBar: AppBar(title: Text('Weather')),
        body: ListView(children: [
          (
            ListTile(
            title: Text(OptionsAPI[0]),
            subtitle: Text(weatherData['weather'][0]["description"] ?? ""),
            onTap: () {
              // Add your action when tapping the card here
            },
          )),
          (
            ListTile(
            title: Text(OptionsAPI[1]),
            subtitle: Text( weatherData['main']["temp"].toString()),
            onTap: () {
              // Add your action when tapping the card here 
            },
          )),
          (
            ListTile(
            title: Text(OptionsAPI[2]),
            subtitle: Text( weatherData['wind']["speed"].toString()),
            onTap: () {
              // Add your action when tapping the card here 
            },
          )),
          (
            ListTile(
            title: Text(OptionsAPI[4]),
            subtitle: Text(weatherData['clouds']["all"].toString()),
            onTap: () {
              // Add your action when tapping the card here 
            },
          ))
        ]));
  }
}
