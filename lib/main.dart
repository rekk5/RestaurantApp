import 'package:flutter/material.dart';
import 'LoginPage.dart'; // Import your login page file here
import 'GenderMetricsPage.dart'; // Import your GenderMetricsPage page file here
import 'HomeScreen.dart';
import 'Feedback.dart';
import 'RestaurantPage.dart';

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
      initialRoute: '/login',
      // Define routes for navigation
      routes: {
        // LoginPage route
        '/login': (context) => const LoginPage(),
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
