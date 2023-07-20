import 'dart:convert';

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

  static Future<List<String>> fetchNews() async {
    // Simulate API call delay (for testing purposes)
    await Future.delayed(Duration(seconds: 1));

    // Mock news data (replace with actual API response when available)
    String newsJson = '''
      [
        "Breaking News: Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        "Sports News: Nulla quis interdum quam. Duis dapibus purus vitae neque posuere, eu consectetur nunc posuere.",
        "Entertainment News: In vel nisi eu risus semper venenatis. Integer eget dolor nec orci finibus congue vel ac purus."
      ]
    ''';

    return List<String>.from(jsonDecode(newsJson));
  }
}
