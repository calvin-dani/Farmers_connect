import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'mock_api_service.dart';

class NewsItem {
  final String headline;
  final String imageUrl;

  NewsItem(this.headline, this.imageUrl);

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(json['headline'], json['imageUrl']);
  }
}

class ApiService {
  static const String newsApiUrl = 'YOUR_NEWS_API_URL';

  static Future<List<NewsItem>> fetchNews() async {
    if (kDebugMode) {
      return MockApiService.fetchNews();
    } else {
      return _fetchNews();
    }
  }

  static Future<dynamic> fetchWeather(Position? _currentPosition) {
    // if (kDebugMode) {
      // print("HERE");
      // return MockApiService.fetchWeather();
    // }
    //  else {
      return _fetchWeather(_currentPosition);
    // }
  }

  // Real API implementation for fetchNews
  static Future<List<NewsItem>> _fetchNews() async {
    final response = await http.get(Uri.parse(newsApiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => NewsItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  // Real API implementation for fetchWeather
  static Future<dynamic> _fetchWeather(Position? _currentPosition) async {
    if (_currentPosition?.latitude != null &&
        _currentPosition?.longitude != null) {
          double lat = _currentPosition?.latitude ?? 0;
          double lon = _currentPosition?.longitude ?? 0;
        print("$lat $lon");
      String weatherApiUrl =
          'https://api.openweathermap.org/data/2.5/weather?lat=33.44&lon=-94.04&appid=42902981ecee4487be71ac3395731ce4';
      final response = await http.get(Uri.parse(weatherApiUrl));
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch weather');
      }
    }
    else {
        throw Exception('Failed to fetch weather');
      }
  }
}
