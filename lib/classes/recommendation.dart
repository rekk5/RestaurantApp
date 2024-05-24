import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/food_type.dart';
import 'package:kandi/classes/menu_item.dart';


List<FoodType> foodTypes = FoodType.getAllFoodTypes();
List<String> likedFoodTypes = [];
Set<String> dislikedFoodTypes = {};
List<int> preferences = [];

class Recommendation{
  //List<MenuItem> recommededItems;
  //List<String> calories;
  List<FoodItem> recommendedItemsFull;

  Recommendation({
    //required this.recommededItems,
    //required this.calories,
    required this.recommendedItemsFull
  });

  static Future<Recommendation> getRecommendations() async{
    // List<MenuItem> recommendedMenu = [];
    // List<String> calories = [];
    // QuerySnapshot recommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection('test').get();
    // for (var menuDoc in recommendationQuery.docs){
    //   print(menuDoc['name']);
    //   recommendedMenu.add(MenuItem(name: menuDoc['name'], price: menuDoc['price'], dishId: menuDoc['dishId']));
    //   calories.add(menuDoc['calories']);
    // }
    likedFoodTypes = [];
    dislikedFoodTypes = {};
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String? userClass = doc['userClass'];
    for(int index = 0; index < doc['foodPreference'].length; index++){
        preferences.add(doc['foodPreference'][index]);
        if(doc['foodPreference'][index] > 0){
          likedFoodTypes.add(foodTypes[index].name);
        }
        if(doc['foodPreference'][index] < 0){
          dislikedFoodTypes.add(foodTypes[index].name);
        }
      }

    print("start");
    String recommendedCollection = getCollectionNameForUserClass(userClass);
    print(recommendedCollection);
    List<FoodItem> recommendedMenu = [];
    if (likedFoodTypes.isEmpty){
      QuerySnapshot recommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection(recommendedCollection).orderBy('nutriscore_int').get();
      for (var document in recommendationQuery.docs){
        Set<String> dishFoodTypes = Set.from(document['food_types']);
        if (dishFoodTypes.intersection(dislikedFoodTypes).isEmpty){
          FoodItem itemToSet = (FoodItem(name: document['name'], totalCalories: double.parse(document['calories']), calories: double.parse(document['calories']), protein: double.parse(document['protein']), fat: double.parse(document['fat']), saturatedFat: double.parse(document['saturated fat']), carbohydrates: double.parse(document['carbs']), sugar: double.parse(document['sugar']), fiber: double.parse(document['fiber']), price: "no price", nutriScore: (document['nutriscore'])));
          print('inRestaurants');
          List<String> possibleRestaurants = List.from(document['inRestaurants']);
      
          if (possibleRestaurants.isEmpty){
            itemToSet.item_restaurant = "not in restaurant";
          }
          else{
            itemToSet.item_restaurant = document['inRestaurants'][0];
            itemToSet.price =  document['prices'][0];
          }
          recommendedMenu.add(itemToSet);
        }
        
    
      }
      Recommendation recommendation = Recommendation(recommendedItemsFull: recommendedMenu);
      return recommendation;
    }
    else {
      print(likedFoodTypes.length);
      QuerySnapshot recommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection(recommendedCollection).where("food_types", arrayContainsAny: likedFoodTypes).orderBy('nutriscore_int').get();
  print("end");
  for (var document in recommendationQuery.docs){
    Set<String> dishFoodTypes = Set.from(document['food_types']);
    if (dishFoodTypes.intersection(dislikedFoodTypes).isEmpty){
      FoodItem itemToSet = (FoodItem(name: document['name'], totalCalories: double.parse(document['calories']), calories: double.parse(document['calories']), protein: double.parse(document['protein']), fat: double.parse(document['fat']), saturatedFat: double.parse(document['saturated fat']), carbohydrates: double.parse(document['carbs']), sugar: double.parse(document['sugar']), fiber: double.parse(document['fiber']), price: "no price", nutriScore: (document['nutriscore'])));
      print('inRestaurants');
      List<String> possibleRestaurants = List.from(document['inRestaurants']);
  
      if (possibleRestaurants.isEmpty){
        itemToSet.item_restaurant = "not in restaurant";
      }
      else{
        itemToSet.item_restaurant = document['inRestaurants'][0];
        print(document['nutriscore_int']);
        itemToSet.price =  document['prices'][0];
        itemToSet.weight = double.parse(document['weight']);
      }
      recommendedMenu.add(itemToSet);
    }
    
  }
  print('3');
  
  if (recommendedMenu.length < 4 && recommendedCollection != "average"){
   
    QuerySnapshot secondRecommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection('average').where("food_types", arrayContainsAny: likedFoodTypes).orderBy('nutriscore_int').get();
    
    for (var document in secondRecommendationQuery.docs){
      if (recommendedMenu.length < 4){
        Set<String> dishFoodTypes = Set.from(document['food_types']);
        if (dishFoodTypes.intersection(dislikedFoodTypes).isEmpty){

          FoodItem itemToSet = (FoodItem(name: document['name'], totalCalories: double.parse(document['calories']), calories: double.parse(document['calories']), protein: double.parse(document['protein']), fat: double.parse(document['fat']), saturatedFat: double.parse(document['saturated fat']), carbohydrates: double.parse(document['carbs']), sugar: double.parse(document['sugar']), fiber: double.parse(document['fiber']), price: "no price", nutriScore: (document['nutriscore'])));
          print('inRestaurants');
          List<String> possibleRestaurants = List.from(document['inRestaurants']);
          if (possibleRestaurants.isEmpty){
            itemToSet.item_restaurant = "not in restaurant";
          }
          else{
            itemToSet.item_restaurant = document['inRestaurants'][0];
            itemToSet.price =  document['prices'][0];
          }
          List<String> names = [];
          for (FoodItem item in recommendedMenu){
            names.add(item.name);
          }
          if (!(names.contains(itemToSet.name))){
          recommendedMenu.add(itemToSet);
          }
        }
      }
    }
  }
  
  //Recommendation recommendation = Recommendation(recommededItems: recommendedMenu, calories: calories);
  Recommendation recommendation = Recommendation(recommendedItemsFull: recommendedMenu);
  return recommendation;
}
  }

  static String getCollectionNameForUserClass(String? userClass){
    if (userClass == null){
      return 'average';
    }
    else if(userClass == "Overweight"){
      return "lowCalorie";
    }
    else if(userClass == "Obese"){
      return "lowCalorie";
    }
    else if(userClass == "Underweight"){
      return "highCalorie";
    }
    else if(userClass == "High Activity"){
      return "highProtein";
    }
    else{
      return 'average';
    }

  }
}