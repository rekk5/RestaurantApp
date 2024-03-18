import 'package:flutter/material.dart';
import 'package:kandi/restaurant_page.dart';
import 'gender_metrics_page.dart'; // Import your GenderMetricsPage file here
import 'feed_back.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the map screen (Not implemented yet)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Map screen is not implemented yet.'),
                  ),
                );
              },
              child: const Text('Map'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the database screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantPage()),
                );
              },
              child: const Text('Database'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the GenderMetricsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenderMetricsPage()),
                );
              },
              child: const Text('Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the FeedbackPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackPage()),
                );
              },
              child: const Text('Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
