import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  String name;
  double totalCalories;
  double weight;
  double calories;
  double protein;
  double fat;
  double saturatedFat;
  double carbohydrates;
  double sugar;
  double fiber;
  String price;
  int healthRating;
  bool fullView = false;

  FoodItem.empty()
      : name = '',
        totalCalories = 0.0,
        weight = 0.0,
        calories = 0.0,
        protein = 0.0,
        fat = 0.0,
        saturatedFat = 0.0,
        carbohydrates = 0.0,
        sugar = 0.0,
        fiber = 0.0,
        price = "0,0",
        healthRating = 0;
    
  FoodItem({
    required this.name,
    required this.totalCalories,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.saturatedFat,
    required this.carbohydrates,
    required this.sugar,
    required this.fiber,
    this.healthRating = 0,
    this.weight = 100,
    required this.price,
  });

  static FoodItem fromDocument(DocumentSnapshot doc, String name, double totalCalories, Map<String, dynamic> fineliData) {
    // Calculate health rating based on calories, protein, and fat
    int healthRating = calculateHealthRating(totalCalories, (fineliData['protein'] as num).toDouble(), (fineliData['fat'] as num).toDouble());
  
    return FoodItem(
      name: name,
      totalCalories: totalCalories,
      calories: (fineliData['calories'] as num).toDouble(),
      protein: (fineliData['protein'] as num).toDouble(),
      fat: (fineliData['fat'] as num).toDouble(),
      saturatedFat: (fineliData['saturated fat'] as num).toDouble(),
      carbohydrates: (fineliData['carbs'] as num).toDouble(),
      sugar: (fineliData['sugar'] as num).toDouble(),
      fiber: (fineliData['fiber'] as num).toDouble(),
      price: doc['price'],
      weight: double.parse(fineliData['medium portion'].replaceAll(",", ".")),
      healthRating: healthRating,
    );
  }
  
  static int calculateHealthRating(double totalCalories, double protein, double fat) {
    // This is just an example. Adjust the calculation based on your specific requirements.
    int healthRating = 0;
    if (totalCalories <= 500 && protein >= 10 && fat <= 10) {
      healthRating = 5;
    } else if (totalCalories <= 600 && protein >= 8 && fat <= 15) {
      healthRating = 4;
    } else if (totalCalories <= 700 && protein >= 6 && fat <= 20) {
      healthRating = 3;
    } else if (totalCalories <= 800 && protein >= 4 && fat <= 25) {
      healthRating = 2;
    } else {
      healthRating = 1;
    }
    return healthRating;
  }

  static set view(bool fullView){
    fullView = fullView;
  }
  static Future<List<FoodItem>> getMenuFromFirebase() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('restaurants').get();
    List<FoodItem> menu = [];
    for (var doc in querySnapshot.docs) {
      QuerySnapshot menuSnapshot = await FirebaseFirestore.instance.collection('restaurants').doc(doc.id).collection('menu').get();
      for (var menuDoc in menuSnapshot.docs) {
        DocumentSnapshot dishDoc = await FirebaseFirestore.instance.collection('dishes').doc(menuDoc['dishId']).get();
        String dishName = dishDoc['name'];
        double totalCalories = 0;
        for (var fineliId in dishDoc['fineliId']) {
          DocumentSnapshot fineliDoc = await FirebaseFirestore.instance.collection('fineli_kaikki').doc(fineliId).get();
          Map<String, dynamic> fineliData = fineliDoc.data() as Map<String, dynamic>;
          double portionSize = double.parse(fineliData['medium portion'].replaceAll(",", "."));
          totalCalories += (fineliData['calories'] * portionSize) / 100;
          menu.add(FoodItem.fromDocument(menuDoc, dishName, totalCalories, fineliData));
        }
      }
    }
    return menu;
  }
  
}