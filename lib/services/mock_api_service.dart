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
          "headline": "Breaking News: Rain Mayhem: IMD puts central Maharashtra on red alert; crop damage expected",
          "imageUrl": "/assets/images/rain.jpeg"
        },
        {
          "headline": "Maharashtra Agriculture Day 2023: Date, History And Significance Of Maharashtra Krishi Din",
          "imageUrl": "/assets/images/agri.jpeg"
        },
        {
          "headline": "Maharashtra: Marathwada agri university makes over 1,000 acres of unused land cultivable",
          "imageUrl": "/assets/images/maha.jpeg"
        }
      ]
    ''';

    final List<dynamic> data = json.decode(newsJson);
    return data.map((item) => NewsItem.fromJson(item)).toList();
  }
}
