import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kandi/classes/food_item.dart';

class Restaurant {
  String name;
  String location;
  List<FoodItem> menu;

  Restaurant({
    required this.name,
    required this.location,
    required this.menu,
  });

  static Future<Restaurant> fromDocument(DocumentSnapshot doc) async {
    List<FoodItem> menu = [];
    for (var menuDoc in (await doc.reference.collection('menu').get()).docs) {
      DocumentSnapshot dishDoc = await FirebaseFirestore.instance.collection('dishes').doc(menuDoc['dishId']).get();
      String dishName = dishDoc['name'];
      double totalCalories = 0;
      Map<String, dynamic> fineliData = {};
      for (var fineliId in dishDoc['fineliId']) {
        DocumentSnapshot fineliDoc = await FirebaseFirestore.instance.collection('fineli_kaikki').doc(fineliId).get();
        fineliData = fineliDoc.data() as Map<String, dynamic>;
        double portionSize = double.parse(fineliData['medium portion'].replaceAll(",", "."));
        totalCalories += (fineliData['calories'] * portionSize) / 100;
      }
      menu.add(FoodItem.fromDocument(menuDoc, dishName, totalCalories, fineliData));
    }
    return Restaurant(
      name: doc['name'],
      location: doc['location'],
      menu: menu,
    );
  }

  static Future<List<Restaurant>> fetchRestaurants() async {
    List<Restaurant> restaurants = [];
    QuerySnapshot restaurantQuery = await FirebaseFirestore.instance.collection('restaurants').get();
    for (var restaurantDoc in restaurantQuery.docs) {
      restaurants.add(await Restaurant.fromDocument(restaurantDoc));
    }
    return restaurants;
  }
}