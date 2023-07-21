import 'dart:convert';
import 'api_service.dart';

class MockApiService {
  static Future<Map<String, dynamic>> fetchWeather() async {
    // Simulate API call delay (for testing purposes)
    await Future.delayed(Duration(seconds: 1));

    // Mock weather data (replace with actual API response when available)
    String weatherJson = '''
      {
        "city": "New York",
        "temperature": 25,
        "description": "Sunny",
        "humidity": 70,
        "windSpeed": 10
      }
    ''';

    return jsonDecode(weatherJson);
  }

  static Future<List<NewsItem>> fetchNews() async {
    // Simulate API call delay (for testing purposes)
    await Future.delayed(Duration(seconds: 1));

    // Mock news data (replace with actual API response when available)
    String newsJson = '''
      [
        {
          "headline": "Breaking News: Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          "imageUrl": "https://example.com/image1.jpg"
        },
        {
          "headline": "Sports News: Nulla quis interdum quam. Duis dapibus purus vitae neque posuere, eu consectetur nunc posuere.",
          "imageUrl": "https://example.com/image2.jpg"
        },
        {
          "headline": "Entertainment News: In vel nisi eu risus semper venenatis. Integer eget dolor nec orci finibus congue vel ac purus.",
          "imageUrl": "https://example.com/image3.jpg"
        }
      ]
    ''';

    final List<dynamic> data = json.decode(newsJson);
    return data.map((item) => NewsItem.fromJson(item)).toList();
  }
}
