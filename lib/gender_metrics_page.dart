import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gender & Metrics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GenderMetricsPage(),
    );
  }
}

class GenderMetricsPage extends StatefulWidget {
  const GenderMetricsPage({super.key});

  @override
  _GenderMetricsPageState createState() => _GenderMetricsPageState();
}

class _GenderMetricsPageState extends State<GenderMetricsPage> {
  String selectedGender = '';
  double weight = 0.0;
  double height = 0.0;
  int age = 0;
  String activityLevel = '';

  void saveMetrics() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('No user is signed in.');
      return;
    }

    final db = FirebaseFirestore.instance;
    db.collection('users').doc(userId).set({
    'gender': selectedGender,
    'weight': weight,
    'height': height,
    'age': age,
    'activityLevel': activityLevel,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gender & Metrics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Gender:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedGender = 'Male';
                    });
                  },
                  child: const Text('Male'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedGender = 'Female';
                    });
                  },
                  child: const Text('Female'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  weight = double.parse(value);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  height = double.parse(value);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  age = int.parse(value);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Age',
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Select Activity Level:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activityLevel = 'Low';
                    });
                  },
                  child: const Text('Low'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activityLevel = 'Medium';
                    });
                  },
                  child: const Text('Medium'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activityLevel = 'High';
                    });
                  },
                  child: const Text('High'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: saveMetrics,
              child: const Text('Save Metrics'),
            ),
          ],
        ),
      ),
    );
  }
}
