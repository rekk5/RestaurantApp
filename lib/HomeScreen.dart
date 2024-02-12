import 'package:flutter/material.dart';
import 'GenderMetricsPage.dart'; // Import your GenderMetricsPage file here

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the map screen (Not implemented yet)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Map screen is not implemented yet.'),
                  ),
                );
              },
              child: Text('Map'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the database screen (Not implemented yet)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Database screen is not implemented yet.'),
                  ),
                );
              },
              child: Text('Database'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the GenderMetricsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenderMetricsPage()),
                );
              },
              child: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
