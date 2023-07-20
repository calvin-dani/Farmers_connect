// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../services/api_service.dart';
import 'weather_page.dart';
import 'news_bulletin_page.dart';
import 'plant_disease_detection_page.dart';
import 'marketplace_page.dart';
import 'miscellaneous_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<String> newsAndNotifications = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  void fetchNews() async {
    try {
      final List<String> news = await ApiService.fetchNews();
      setState(() {
        newsAndNotifications = news;
      });
    } catch (e) {
      // Handle the error
      print('Error fetching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmers Connect'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Open the drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      drawer: buildDrawer(), // Add the drawer
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Welcome back, CalShek!', style: TextStyle(fontSize: 24.0)),
            SizedBox(height: 16.0),
            // Set a specific height for the News Bulletin swiper
            Container(
              height: 200.0,
              child: newsAndNotifications.isEmpty
                  ? Center(child: Text('No news available.'))
                  : Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          // Display fetched news or notification data
                          child:
                              Center(child: Text(newsAndNotifications[index])),
                        );
                      },
                      itemCount: newsAndNotifications.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                    ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: WeatherCard()),
                  SizedBox(width: 16.0),
                  Expanded(
                      child:
                          PlantDiseaseDetectionPage()), // Use PlantDiseaseDetectionCard here
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: MarketplaceCard()),
                  SizedBox(width: 16.0),
                  Expanded(child: MiscellaneousCard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Implement the navigation to the Settings page here
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Implement the navigation to the Profile page here
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Implement the navigation to the About page here
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contact Us'),
            onTap: () {
              // Implement the navigation to the Contact Us page here
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
