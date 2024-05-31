import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kandi/classes/restaurant_data.dart';
import 'package:provider/provider.dart';
import 'gender_metrics_page.dart'; // Import your GenderMetricsPage page file here
import 'home_screen.dart';
import 'feed_back.dart';
import 'restaurant_page.dart';
import 'login.dart';
import 'register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Set initial route to LoginPage
        initialRoute: user != null ? '/homescreen' : '/login',
        // Define routes for navigation
        routes: {
          // gendermetricspage route
          '/gendermetricspage': (context) => const GenderMetricsPage(),
          // HomeScreen route
          '/homescreen': (context) => const HomeScreen(),
          // Feedback route
          '/feedback': (context) => const FeedbackPage(),
          // RestaurantPage route
          '/RestaurantPage': (context) => const RestaurantPage(),
          // LoginPage route
          '/login': (context) => const LoginPage(),
          // RegisterPage route
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}
