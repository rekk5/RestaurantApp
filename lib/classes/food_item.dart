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
  String nutriScore;
  String restaurant ;


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
        healthRating = 0,
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
    this.healthRating = 0,
    this.weight = 100,
    required this.price,
    required this.nutriScore,
    this.restaurant = ""

  });

  set item_restaurant(String restaurant){
    this.restaurant = restaurant;
  }

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
      nutriScore: 'C'
    );
  }

    static FoodItem fromMenuView(String price, String name, double totalCalories, Map<String, dynamic> fineliData) {
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
      price: price,
      weight: double.parse(fineliData['medium portion'].replaceAll(",", ".")),
      healthRating: healthRating,
      nutriScore: 'C',
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

  // static Future<FoodItem> getClickedFoodItemFromFirebase(String dishName, String price, String dishId) async {
  //   DocumentSnapshot dishDoc = await FirebaseFirestore.instance.collection('dishes').doc(dishId).get();
  //   // String dishName = dishDoc['name'];
  //   // print(dishName);
  //   double totalCalories = 0;
  //   Map<String, dynamic> fineliData = {};
  //   for (var fineliId in dishDoc['fineliId']) {
  //     DocumentSnapshot fineliDoc = await FirebaseFirestore.instance.collection('fineli_kaikki').doc(fineliId).get();
  //     fineliData = fineliDoc.data() as Map<String, dynamic>;
  //     double portionSize = double.parse(fineliData['medium portion'].replaceAll(",", "."));
  //     totalCalories += (fineliData['calories'] * portionSize) / 100;
  //   }

  //   return FoodItem.fromMenuView(price, dishName, totalCalories, fineliData);
  // }

  static Future<FoodItem> getClickedFoodItemFromFirebase2(String dishName, String price, String dishId) async {
    DocumentSnapshot dishDoc = await FirebaseFirestore.instance.collection('dishes').doc(dishId).get();
    // String dishName = dishDoc['name'];
    // print(dishName);
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
      price: price,
      weight: double.parse(dishDoc['weight']),
      healthRating: 0,
      nutriScore: dishDoc['nutriscore'],
    );
  }

  static List<FoodItem> getTestMenu(){
    List<FoodItem> testMenu = [];

    // testMenu.add(
    //   FoodItem(name: 'Big Mac',
    //   totalCalories: 542,
    //   calories: 230.7,
    //   protein: 11.5,
    //   fat: 12.3,
    //   saturatedFat: 4.3,
    //   carbohydrates: 17.9,
    //   sugar: 3.7,
    //   healthRating: 3,
    //   weight: (100*542/230.7),
    //   price: '5.95',
    //   fiber: 3.7,
    //   )
    // );

    // testMenu.add(
    //   FoodItem(name: 'Fiesta Chicken Salad',
    //   totalCalories: 420,
    //   calories: 118.3,
    //   protein: 6.5,
    //   fat: 7.6,
    //   saturatedFat: 1.9,
    //   carbohydrates: 5.9,
    //   sugar: 1.7,
    //   healthRating: 1,
    //   weight: (100*420/118.3),
    //   price: '7.95',
    //   fiber: 5.3,

    //   )
    // );

    // testMenu.add(
    //   FoodItem(name: 'Classic McWrap Veggie',
    //   totalCalories: 459,
    //   calories: 227,
    //   protein: 11,
    //   fat: 11,
    //   saturatedFat: 1.2,
    //   carbohydrates: 22,
    //   sugar: 1.6,
    //   healthRating: 2,
    //   weight: (100*459/227),
    //   price: '4.95',
    //   fiber: 8.3,

    //   )
    // );

    // testMenu.add(
    //   FoodItem(name: 'Chocolate Sundae Mix',
    //   totalCalories: 373,
    //   calories: 192,
    //   protein: 3.4,
    //   fat: 5,
    //   saturatedFat: 3.7,
    //   carbohydrates: 34,
    //   sugar: 32,
    //   healthRating: 3,
    //   weight: (100*373/192),
    //   price: '2.95',
    //   fiber: 0.1,

    //   )
    // );

    // testMenu.add(
    //   FoodItem(name: 'Mini Salad',
    //   totalCalories: 25,
    //   calories: (25/1.55).roundToDouble(),
    //   protein: 1,
    //   fat: 0.2,
    //   saturatedFat: 0.1,
    //   carbohydrates: 2.1,
    //   sugar: 2,
    //   healthRating: 0,
    //   weight: 155,
    //   price: '3.95',
    //   fiber: 3.5,
    //   )
    // );


    return testMenu;
  }
  
}