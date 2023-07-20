// miscellaneous_page.dart
import 'package:flutter/material.dart';

class MiscellaneousCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Implement the navigation to the Miscellaneous page here
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.miscellaneous_services, size: 80.0),
            SizedBox(height: 8.0),
            Text('Miscellaneous', style: TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
    );
  }
}
