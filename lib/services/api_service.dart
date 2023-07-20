import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'mock_api_service.dart';

class ApiService {
  static const String newsApiUrl = 'YOUR_NEWS_API_URL';
  static const String weatherApiUrl = 'YOUR_WEATHER_API_URL';

  static Future<List<String>> fetchNews() {
    if (kDebugMode) {
      return MockApiService.fetchNews();
    } else {
      return _fetchNews();
    }
  }

  static Future<Object> fetchWeather() {
    if (kDebugMode) {
      return MockApiService.fetchWeather();
    } else {
      return _fetchWeather();
    }
  }

  // Real API implementation for fetchNews
  static Future<List<String>> _fetchNews() async {
    final response = await http.get(Uri.parse(newsApiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['title'].toString()).toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  // Real API implementation for fetchWeather
  static Future<String> _fetchWeather() async {
    final response = await http.get(Uri.parse(weatherApiUrl));
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return data['weather'].toString();
    } else {
      throw Exception('Failed to fetch weather');
    }
  }
}