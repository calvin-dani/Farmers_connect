// news_bulletin_page.dart
import 'package:flutter/material.dart';

class NewsBulletinCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the News Bulletin page
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewsBulletinPage()));
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/news_icon.png', height: 80.0, width: 80.0),
            SizedBox(height: 8.0),
            Text('News Bulletin', style: TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
    );
  }
}

class NewsBulletinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Bulletin')),
      body: Center(
        // Implement the news bulletin details UI
        child: Text('News bulletin details will be shown here.'),
      ),
    );
  }
}
