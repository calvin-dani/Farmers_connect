import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/services/api_service.dart';
import '../auth.dart';
import 'marketplace_page.dart';
import 'plant_disease_detection_card.dart';
import 'weather_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<NewsItem> newsAndNotifications = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
    // _getLocation();
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

  void fetchNews() async {
    try {
      final List<NewsItem> news = await ApiService.fetchNews();
      setState(() {
        newsAndNotifications = news;
      });
    } catch (e) {
      // Handle the error
      print('Error fetching news: $e');
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FarmersConnect',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 62, 147, 67),
      ),
      drawer: buildDrawer(), // Add the drawer
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Welcome Back!',
                style: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            // Set a specific height for the News Bulletin swiper
            Container(
              height: 200.0,
              child: newsAndNotifications.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.asset(
                                'assets${newsAndNotifications[index].imageUrl}',
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.green[900]!
                                    ],
                                    stops: [0.5, 1.0],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  newsAndNotifications[index].headline,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green, width: 3.0),
                          ),
                        );
                      },
                      itemCount: newsAndNotifications.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                    ),
            ),
            SizedBox(height: 16.0),
            WeatherCard(),
            SizedBox(height: 16.0),
            PlantDiseaseDetectionCard(),
            SizedBox(height: 16.0),
            MarketplaceCard(),
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
              color: const Color.fromARGB(255, 62, 147, 67), // Color of the app
            ),
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            margin: EdgeInsets.zero, // Remove bottom margin
            padding: EdgeInsets.all(16.0), // Add some padding
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
            leading: Icon(Icons.exit_to_app_rounded),
            title: Text('Sign out'),
            onTap: () {
              // Implement the navigation to the Contact Us page here
              Navigator.pop(context); // Close the drawer
              signOut();
            },
          ),
        ],
      ),
    );
  }
}
