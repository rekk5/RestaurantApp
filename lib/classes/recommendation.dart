import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/food_type.dart';

// recommendations will query extra items from all dishes instedad of the userClass specific collection if userClass specific collection has this amount or fewer recommended dishes 
const int TOO_FEW_RECOMMENDATIONS = 3;
// list of all food types
final List<FoodType> _foodTypes = FoodType.getAllFoodTypes();
// initialize liked and disliked food typws
List<String> _likedFoodTypes = [];
Set<String> _dislikedFoodTypes = {};
List<int> _preferences = [];



class Recommendation{
  List<FoodItem> recommendedItems;

  Recommendation({
    required this.recommendedItems
  });

  static Future<Recommendation> getRecommendations() async{
    // restaurant ratings dictionary for selecting the best option for same dish in multiple restaurants
    Map restaurantRatings = {};
    // get restaurant ratings from firebase
    final restaurantsQuery = await FirebaseFirestore.instance.collection('restaurants').get();
    for (DocumentSnapshot restaurantDoc in restaurantsQuery.docs){
      restaurantRatings[restaurantDoc['name']] = restaurantDoc['rating'];
    }

    // get user's liked and disliked food types from firebase 
    _likedFoodTypes = [];
    _dislikedFoodTypes = {};
    final userId = FirebaseAuth.instance.currentUser?.uid;
    //get user data from firebase
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.data().toString().contains('foodPreference')){
      for(int index = 0; index < doc['foodPreference'].length; index++){
          _preferences.add(doc['foodPreference'][index]);
          if(doc['foodPreference'][index] > 4){
            _likedFoodTypes.add(_foodTypes[index].name);
          }
          if(doc['foodPreference'][index] < 1){
            _dislikedFoodTypes.add(_foodTypes[index].name);
          }
        }
    }

    // get user class from firebase to choose correct recommended dishes collection
    String? userClass;
    doc.data().toString().contains('userClass') ? userClass  = doc['userClass'] : "Average";
    String recommendedCollection = getCollectionNameForUserClass(userClass);

    // initialize recommended items menu
    List<FoodItem> recommendedMenu = [];
    
    // if user has not set liked food types recommendations gets all dishes sorted by nutri score and removes ones with food types in _dislikedFoodTypes set
    if (_likedFoodTypes.isEmpty){
      QuerySnapshot recommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection(recommendedCollection).orderBy('nutriscore_int').get();
      for (var document in recommendationQuery.docs){
        _addRecommendedItemToRecommendationList(document, recommendedMenu, restaurantRatings);
      }
      Recommendation recommendation = Recommendation(recommendedItems: recommendedMenu);
      return recommendation;
    }
    // if user has liked food types, only gets dishes with at least one of those food types (dishes with both liked and disliked food types will not be removed)
    else {
      QuerySnapshot recommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection(recommendedCollection).where("food_types", arrayContainsAny: _likedFoodTypes).orderBy('nutriscore_int').get();
      for (var document in recommendationQuery.docs){
        _addRecommendedItemToRecommendationList(document, recommendedMenu, restaurantRatings);
      }
      
      // if number of recommendations is too few
      if (recommendedMenu.length <= TOO_FEW_RECOMMENDATIONS && recommendedCollection != "average"){
      
        QuerySnapshot secondRecommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection('average').where("food_types", arrayContainsAny: _likedFoodTypes).orderBy('nutriscore_int').get();
        
        for (var document in secondRecommendationQuery.docs){
          if (recommendedMenu.length <= TOO_FEW_RECOMMENDATIONS){
            _addRecommendedItemToRecommendationList(document, recommendedMenu, restaurantRatings);
          }
        }
      }
      
      Recommendation recommendation = Recommendation(recommendedItems: recommendedMenu);
      return recommendation;
    }
  }
  
  // creates FoodItem from firebase document and chooses the highest rated restaurtant, adds to recommendedMenu (if dish has no disliked food types)
  static void _addRecommendedItemToRecommendationList(DocumentSnapshot document, List<FoodItem> recommendedMenu, Map restaurantRatings){
    Set<String> dishFoodTypes = Set.from(document['food_types']);
    if (dishFoodTypes.intersection(_dislikedFoodTypes).isEmpty){
      FoodItem itemToSet = FoodItem(
      name: document['name'],
      totalCalories: double.parse(document['calories']),
      calories: double.parse(document['calories']),
      protein: double.parse(document['protein']),
      fat: double.parse(document['fat']),
      saturatedFat: double.parse(document['saturated fat']),
      carbohydrates: double.parse(document['carbs']),
      sugar: double.parse(document['sugar']),
      fiber: double.parse(document['fiber']),
      salt: double.parse(document['salt']),
      price: "no price",
      nutriScore: (document['nutriscore'])
      );
      itemToSet.weight = double.parse(document['weight']);
      List<String> possibleRestaurants = List.from(document['inRestaurants']);

      // if dish not in any restaurant restaurant field has value "not in restaurant"
      if (possibleRestaurants.isEmpty){
        itemToSet.itemRestaurant = "not in restaurant";
      }
      // else sets restyaurant and price of the highest rated restaurant
      else{
        int highestRatedIndex = getHighestRatedRestaurantIndex(restaurantRatings, possibleRestaurants);
        itemToSet.itemRestaurant = document['inRestaurants'][highestRatedIndex];
        itemToSet.price =  document['prices'][highestRatedIndex];
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