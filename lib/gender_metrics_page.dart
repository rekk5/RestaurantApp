import 'dart:ffi';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/food_type.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';



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
  String userClass = '';

  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  static List<FoodType> foodTypes = FoodType.getAllFoodTypes();

  static List<FoodType> _smallFoodTypes = [];
  static List<FoodType> _smallFoodTypes2 = [];

  

  final _items = foodTypes.map((foodItem) => MultiSelectItem(foodItem, foodItem.name)).toList();
  
  List<FoodType> likedFoodTypes = [];
  List<FoodType> dislikedFoodTypes = [];
  List<int> preferences = [];


  @override
  void initState() {
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
      // setting food preferences
      likedFoodTypes = [];
      dislikedFoodTypes = [];
      for(int index = 0; index < doc['foodPreference'].length; index++){
        preferences.add(doc['foodPreference'][index]);
        if(doc['foodPreference'][index] > 0){
          likedFoodTypes.add(foodTypes[index]);
        }
        if(doc['foodPreference'][index] < 0){
          dislikedFoodTypes.add(foodTypes[index]);
        }
      }
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
    'foodPreference': getFoodPreferenceList(),
    'userClass': classifyUser(height, weight, age, selectedGender, activityLevel)
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
              _genderSelector(),
          
              const SizedBox(height: 20.0),
              _weightSelector(),
          
              const SizedBox(height: 10.0),
              _heightSelector(),
          
              const SizedBox(height: 10.0),
              _ageSelector(),
          
              const SizedBox(height: 20.0),
              _activityLevelText(),
          
              const SizedBox(height: 10.0),
              _activityLevelSelector(),

              const SizedBox(height: 10.0),


             MultiSelectDialogField<FoodType>(
              items: _items,
              initialValue: likedFoodTypes,
              title: Text('Food types'),
              buttonText: Text('Select the food types you like...'),
              selectedColor: Colors.green,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40)
              ),

              onConfirm: (results){
                likedFoodTypes = results;
              }
              ),

              const SizedBox(height: 40.0),


              MultiSelectDialogField<FoodType>(
              items: _items,
              initialValue: dislikedFoodTypes,
              title: Text('Food types'),
              buttonText: Text('Select the food types you dislike...'), 
              selectedColor: Colors.red,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40)
              ),

              onConfirm: (results){
                dislikedFoodTypes = results;
              }
              ),
            
              const SizedBox(height: 20.0),


              ElevatedButton(
                onPressed: saveMetrics,
                child: const Text('Save Metrics'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _activityLevelSelector() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        activityLevel = 'Very Low';
                      });
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(1.0)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (activityLevel == 'Very Low') return Colors.blue;  // Selected color
                          return Colors.grey;  // Default color
                        },
                      ),
                    ),
                    child: const Text('Very Low'),
                  ),
                ),
      
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        activityLevel = 'Low';
                      });
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(1.0)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (activityLevel == 'Low') return Colors.blue;  // Selected color
                          return Colors.grey;  // Default color
                        },
                      ),
                    ),
                    child: const Text('Low'),
                  ),
                ),
      
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        activityLevel = 'Medium';
                      });
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(1.0)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (activityLevel == 'Medium') return Colors.blue;  // Selected color
                          return Colors.grey;  // Default color
                        },
                      ),
                    ),
                    child: const Text('Medium'),
                  ),
                ),
      
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        activityLevel = 'High';
                      });
                    },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(1.0)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (activityLevel == 'High') return Colors.blue;  // Selected color
                        return Colors.grey;  // Default color
                      },
                    ),
                  ),
                  child: const Text('High'),
                                ),
                ),
      
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  
                    onPressed: () {
                      setState(() {
                        activityLevel = 'Very High';
                      });
                    },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(1.0)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (activityLevel == 'Very High') return Colors.blue;  // Selected color
                        return Colors.grey;  // Default color
                      },
                    ),
                  ),
                  child: const Text('Very High'),
                ),
              ),
            ],
          );
  
  }


  List<int> getFoodPreferenceList(){
    List<int> foodPreferenceList = List.filled(foodTypes.length, 0);
    for(FoodType food in likedFoodTypes){
      foodPreferenceList[food.id] = 1;
    }
    for(FoodType food in dislikedFoodTypes){
      foodPreferenceList[food.id] = -1;
    }

    return foodPreferenceList;
  }

  Text _activityLevelText() {
    return const Text(
            'Select Activity Level:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          );
  }

  TextField _ageSelector() {
    return TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                if (value == ""){
                  value = "0";
                }
                age = int.parse(value);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Age',
            ),
          );
  }

  TextField _heightSelector() {
    return TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                if (value == ""){
                  value = "0.0";
                }
                height = double.parse(value);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
            ),
          );
  }

  TextField _weightSelector() {
    return TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                if (value == ""){
                  value = "0.0";
                }
                weight = double.parse(value);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
            ),
          );
  }

  Row _genderSelector() {
    return Row(
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
          );
  }

  String classifyUser(double height, double weight, int age, String gender, String activityLevel){
    double heightMeters = height/100;
    double BMI = weight/(heightMeters * heightMeters);
    if (BMI < 18.5){
      return "Underweight";
    }
    if (BMI >= 30){
      return "Obese";
    }
    if (BMI >= 25){
      return "Overweight";
    }
    if (activityLevel == "Very High"){
      return "High Activity";
    }
    return "Normal";
  }
}
