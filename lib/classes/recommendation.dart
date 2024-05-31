import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/food_type.dart';
import 'package:kandi/classes/restaurant.dart';


final List<FoodType> foodTypes = FoodType.getAllFoodTypes();
List<String> likedFoodTypes = [];
Set<String> dislikedFoodTypes = {};
List<int> preferences = [];

class Recommendation{
  List<FoodItem> recommendedItems;

  Recommendation({
    required this.recommendedItems
  });

  static Future<Recommendation> getRecommendations() async{

    Map restaurantRatings = {};

    final restaurantsQuery = await FirebaseFirestore.instance.collection('restaurants').get();
    for (DocumentSnapshot restaurantDoc in restaurantsQuery.docs){
      restaurantRatings[restaurantDoc['name']] = restaurantDoc['rating'];
    }
    print(restaurantRatings);


    likedFoodTypes = [];
    dislikedFoodTypes = {};
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String? userClass;
    doc.data().toString().contains('userClass') ? userClass  = doc['userClass'] : "Average";


    if (doc.data().toString().contains('foodPreference')){
      for(int index = 0; index < doc['foodPreference'].length; index++){
          preferences.add(doc['foodPreference'][index]);
          if(doc['foodPreference'][index] > 4){
            likedFoodTypes.add(foodTypes[index].name);
          }
          if(doc['foodPreference'][index] < 1){
            dislikedFoodTypes.add(foodTypes[index].name);
          }
        }
    }


    String recommendedCollection = getCollectionNameForUserClass(userClass);
    List<FoodItem> recommendedMenu = [];
    if (likedFoodTypes.isEmpty){
      QuerySnapshot recommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection(recommendedCollection).orderBy('nutriscore_int').get();
      print(recommendedCollection);
      for (var document in recommendationQuery.docs){
        print(document.id);
        print(document['name']);
        print(document['food_types']);
        _addRecommendedItemToRecommendationList(document, recommendedMenu, restaurantRatings);
        
    
      }
      Recommendation recommendation = Recommendation(recommendedItems: recommendedMenu);
      return recommendation;
    }
    else {
      QuerySnapshot recommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection(recommendedCollection).where("food_types", arrayContainsAny: likedFoodTypes).orderBy('nutriscore_int').get();
      for (var document in recommendationQuery.docs){
        _addRecommendedItemToRecommendationList(document, recommendedMenu, restaurantRatings);
        
      }
      
      if (recommendedMenu.length < 4 && recommendedCollection != "average"){
      
        QuerySnapshot secondRecommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection('average').where("food_types", arrayContainsAny: likedFoodTypes).orderBy('nutriscore_int').get();
        
        for (var document in secondRecommendationQuery.docs){
          if (recommendedMenu.length < 4){
            _addRecommendedItemToRecommendationList(document, recommendedMenu, restaurantRatings);
          }
        }
      }
      
      Recommendation recommendation = Recommendation(recommendedItems: recommendedMenu);
      return recommendation;
    }
  }
  
  static void _addRecommendedItemToRecommendationList(DocumentSnapshot document, List<FoodItem> recommendedMenu, Map restaurantRatings){
    Set<String> dishFoodTypes = Set.from(document['food_types']);
    if (dishFoodTypes.intersection(dislikedFoodTypes).isEmpty){
      FoodItem itemToSet = (FoodItem(name: document['name'], totalCalories: double.parse(document['calories']), calories: double.parse(document['calories']), protein: double.parse(document['protein']), fat: double.parse(document['fat']), saturatedFat: double.parse(document['saturated fat']), carbohydrates: double.parse(document['carbs']), sugar: double.parse(document['sugar']), fiber: double.parse(document['fiber']), price: "no price", nutriScore: (document['nutriscore'])));
      List<String> possibleRestaurants = List.from(document['inRestaurants']);
  
      if (possibleRestaurants.isEmpty){
        itemToSet.itemRestaurant = "not in restaurant";
      }
      else{
        int highestRatedIndex = getHighestRatedRestaurantIndex(restaurantRatings, possibleRestaurants);
        itemToSet.itemRestaurant = document['inRestaurants'][highestRatedIndex];
        itemToSet.price =  document['prices'][highestRatedIndex];
        itemToSet.weight = double.parse(document['weight']);
      }
      recommendedMenu.add(itemToSet);
    }
  }

  //returns the name of the recommended dishes firebase collection for the userClass of the user
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

  // returns the index of the highest rated restaurant in the list possibleRestaurants, -1 if possibleRestaurants in empty
  static int getHighestRatedRestaurantIndex(Map restaurantRatings, List<String> possibleRestaurants){
    if (restaurantRatings.isEmpty){
      throw 'Ratings list empty. Restaurants of firebase restaurant collection missing field rating or ratings not retrieved from firebase';
    }
    else if (possibleRestaurants.isEmpty){
      return -1;
    }
    else{
      String bestRestaurant = "";
      double maxRating = 0;
      for (String restaurant in possibleRestaurants){
        if (restaurantRatings[restaurant] > maxRating){
          maxRating = restaurantRatings[restaurant];
          bestRestaurant = restaurant;
        }
      }
      return(possibleRestaurants.indexOf(bestRestaurant));
    }
  }

}