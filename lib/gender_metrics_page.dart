import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kandi/classes/food_type.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';


class GenderMetricsPage extends StatefulWidget {
  const GenderMetricsPage({super.key});

  @override
  _GenderMetricsPageState createState() => _GenderMetricsPageState();
}


class _GenderMetricsPageState extends State<GenderMetricsPage> {
  String _selectedGender = '';
  double _weight = 0.0;
  double _height = 0.0;
  int _age = 0;
  String _activityLevel = '';
  // String _userClass = ''; 

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  static final List<FoodType> foodTypes = FoodType.getAllFoodTypes();


  final _items = foodTypes.map((foodItem) => MultiSelectItem(foodItem, foodItem.name)).toList();
  
  List<FoodType> _likedFoodTypes = [];
  List<FoodType> _dislikedFoodTypes = [];
  final List<int> _preferences = [];


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
    // get user daat from firebase
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      // tries to get user metrics, handles null if metric not in firebase
      doc.data().toString().contains('gender') ? _selectedGender = doc['gender'] : _selectedGender = 'not selected';
      doc.data().toString().contains('weight') ? _weight = doc['weight'] : _weight = 0.0;
      doc.data().toString().contains('height') ? _height = doc['height'] : _height = 0.0;
      doc.data().toString().contains('age') ? _age = doc['age'] : _age = 0;
      doc.data().toString().contains('age') ? _activityLevel = doc['activityLevel'] : _activityLevel = 'not selected';

      //sets metric texts
      _weight > 0 ? _weightController.text = _weight.toString() : _weightController.text = "";
      _height > 0 ? _heightController.text = _height.toString() : _weightController.text = "";
      _age > 0 ? _ageController.text = _age.toString() : _ageController.text = "";
      // setting food preferences
      // stored in firebase as array where each index has one of 3 values (0 = disliked, 3 = neutral, 5 = liked)
      _likedFoodTypes = [];
      _dislikedFoodTypes = [];
      if (doc.data().toString().contains('foodPreference')){
        for(int index = 0; index < doc['foodPreference'].length; index++){
        _preferences.add(doc['foodPreference'][index]);
        if(doc['foodPreference'][index] > 4){
          _likedFoodTypes.add(foodTypes[index]);
        }
        if(doc['foodPreference'][index] < 1){
          _dislikedFoodTypes.add(foodTypes[index]);
        }
      }
    }
    });
  }
  // store new user metrics to firebase
  void saveMetrics() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('No user is signed in.');
      return;
    }

    final db = FirebaseFirestore.instance;
    db.collection('users').doc(userId).set({
    'gender': _selectedGender,
    'weight': _weight,
    'height': _height,
    'age': _age,
    'activityLevel': _activityLevel,
    'foodPreference': _getFoodPreferenceList(),
    'userClass': _classifyUser(_height, _weight, _age, _selectedGender, _activityLevel)
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _selectGenderText(),

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
             _likedFoodTypesSelector(),

              const SizedBox(height: 40.0),
              _dislikedFoodTypesSelector(),
            
              const SizedBox(height: 20.0),
              _saveMetricsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Text _selectGenderText() {
    return const Text(
      'Select Gender:',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  ElevatedButton _saveMetricsButton() {
    return ElevatedButton(
      onPressed: saveMetrics,
      child: const Text('Save Metrics'),
    );
  }

  MultiSelectDialogField<FoodType> _dislikedFoodTypesSelector() {
    return MultiSelectDialogField<FoodType>(
      items: _items,
      initialValue: _dislikedFoodTypes,
      title: const Text('Food types'),
      buttonText: const Text('Select the food types you dislike...'), 
      selectedColor: Colors.red,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40)
      ),

      onConfirm: (results){
        _dislikedFoodTypes = results;
      }
    );
  }

  MultiSelectDialogField<FoodType> _likedFoodTypesSelector() {
    return MultiSelectDialogField<FoodType>(
      items: _items,
      initialValue: _likedFoodTypes,
      title: const Text('Food types'),
      buttonText: const Text('Select the food types you like...'),
      selectedColor: Colors.green,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40)
      ),

      onConfirm: (results){
        _likedFoodTypes = results;
      }
      );
  }


  Row _activityLevelSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 1,
          child: _setActivityLevelButton('Very Low')
        ),

        Flexible(
          flex: 1,
          child: _setActivityLevelButton('Low')
        ),

        Flexible(
          flex: 1,
          child: _setActivityLevelButton('Medium')
        ),

        Flexible(
          flex: 1,
          child:_setActivityLevelButton('High')
        ),

        Flexible(
          flex: 1,
          child: _setActivityLevelButton('Very High')
        ),
      ],
    );
  
  }

  ElevatedButton _setActivityLevelButton(String activityLevelString){
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _activityLevel = activityLevelString;
        });
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.all(1.0)),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (_activityLevel == activityLevelString) return Colors.blue;  // Selected button shows different color
            return Colors.grey;  // Default color
          },
        ),
      ),
      child: Text(activityLevelString),
    );
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
      controller: _ageController,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          if (value == ""){
            value = "0";
          }
          _age = int.parse(value);
        });
      },
      decoration: const InputDecoration(
        labelText: 'Age',
      ),
    );
  }

  TextField _heightSelector() {
    return TextField(
      controller: _heightController,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          if (value == ""){
            value = "0.0";
          }
          _height = double.parse(value);
        });
      },
      decoration: const InputDecoration(
        labelText: 'Height (cm)',
      ),
    );
  }

  TextField _weightSelector() {
    return TextField(
      controller: _weightController,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          if (value == ""){
            value = "0.0";
          }
          _weight = double.parse(value);
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
              _selectedGender = 'Male';
            });
          },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (_selectedGender == 'Male') return Colors.blue;  // Selected color
                return Colors.grey;  // Default color
            },
          ),
          ),
        child: const Text('Male'),
        ),

        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedGender = 'Female';
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (_selectedGender == 'Female') return Colors.blue;  // Selected color
                  return Colors.grey;  // Default color
              },
            ),
          ),
        child: const Text('Female'),
        ),
      ],
    );
  }

  List<int> _getFoodPreferenceList(){
    List<int> foodPreferenceList = List.filled(foodTypes.length, 3);
    for(FoodType food in _likedFoodTypes){
      foodPreferenceList[food.id] = 5;
    }
    for(FoodType food in _dislikedFoodTypes){
      foodPreferenceList[food.id] = 0;
    }

    return foodPreferenceList;
  }

  String _classifyUser(double height, double weight, int age, String gender, String activityLevel){
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
    return "Average";
  }
}
