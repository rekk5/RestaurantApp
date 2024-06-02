import 'package:cloud_firestore/cloud_firestore.dart';


// FoodItem class represents a dish 


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
  double salt;
  String price;
  bool fullView = false;
  String nutriScore;
  String restaurant ;


  FoodItem.empty()
      : name = '',
        totalCalories = 0.0,
        weight = 0.0,
        calories = 0.0,
        protein = 0.0,
        fat = 0.0,
        salt = 0.0,
        saturatedFat = 0.0,
        carbohydrates = 0.0,
        sugar = 0.0,
        fiber = 0.0,
        price = "0,0",
        nutriScore = 'C',
        restaurant = "";
    
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
    required this.salt,
    this.weight = 100,
    required this.price,
    required this.nutriScore,
    this.restaurant = ""
  });

  set itemRestaurant(String restaurant){
    this.restaurant = restaurant;
  }

  static Future<FoodItem> getClickedFoodItemFromFirebase(String dishName, String price, String dishId) async {
    DocumentSnapshot dishDoc = await FirebaseFirestore.instance.collection('dishes').doc(dishId).get();
    double totalCalories = double.parse(dishDoc['calories']) *  double.parse(dishDoc['weight'])/100;
    
    return FoodItem(
      name: dishName,
      totalCalories: totalCalories,
      calories: double.parse(dishDoc['calories']),
      protein: double.parse(dishDoc['protein']),
      fat: double.parse(dishDoc['fat']),
      saturatedFat: double.parse(dishDoc['saturated fat']),
      carbohydrates: double.parse(dishDoc['carbs']),
      sugar: double.parse(dishDoc['sugar']),
      fiber: double.parse(dishDoc['fiber']),
      salt: double.parse(dishDoc['salt']),
      price: price,
      weight: double.parse(dishDoc['weight']),
      nutriScore: dishDoc['nutriscore'],
    );
  }

}