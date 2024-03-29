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

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMetrics();
  }

  void loadMetrics() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('No user is signed in.');
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      selectedGender = doc['gender'];
      weight = doc['weight'];
      height = doc['height'];
      age = doc['age'];
      activityLevel = doc['activityLevel'];

      weightController.text = weight.toString();
      heightController.text = height.toString();
      ageController.text = age.toString();
    });
  }

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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (selectedGender == 'Male') return Colors.blue;  // Selected color
                        return Colors.grey;  // Default color
                    },
                  ),
                 ),
                child: const Text('Male'),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedGender = 'Female';
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (selectedGender == 'Female') return Colors.blue;  // Selected color
                          return Colors.grey;  // Default color
                      },
                    ),
                  ),
                child: const Text('Female'),
                ),
              ],
            ),

            const SizedBox(height: 20.0),
            TextField(
              controller: weightController,
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
              controller: heightController,
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
              controller: ageController,
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
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (activityLevel == 'Low') return Colors.blue;  // Selected color
                        return Colors.grey;  // Default color
                      },
                    ),
                  ),
                  child: const Text('Low'),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activityLevel = 'Medium';
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (activityLevel == 'Medium') return Colors.blue;  // Selected color
                        return Colors.grey;  // Default color
                      },
                    ),
                  ),
                  child: const Text('Medium'),
                ),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activityLevel = 'High';
                    });
                  },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (activityLevel == 'High') return Colors.blue;  // Selected color
                      return Colors.grey;  // Default color
                    },
                  ),
                ),
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
