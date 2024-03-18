import 'package:flutter/material.dart';
import 'gender_metrics_page.dart'; // Import your GenderMetricsPage page file here
import 'home_screen.dart';
import 'feed_back.dart';
import 'restaurant_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set initial route to LoginPage
      initialRoute: '/homescreen',
      // Define routes for navigation
      routes: {
        // gendermetricspage route
        '/gendermetricspage': (context) => const GenderMetricsPage(),
        // HomeScreen route
        '/homescreen': (context) => const HomeScreen(),
        // Feedback route
        '/feedback': (context) => const FeedbackPage(),
        // RestaurantPage route
        '/RestaurantPage': (context) => RestaurantPage(),
      },
    );
  }
}
