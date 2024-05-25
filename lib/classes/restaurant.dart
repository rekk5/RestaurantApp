import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/menu_item.dart';

class Restaurant {
  String name;
  String location;
  List<MenuItem> menuView;
  List<MenuItem> topDishes;

  Restaurant({
    required this.name,
    required this.location,
    required this.menuView,
    required this.topDishes,
  });

  static Future<Restaurant> fromDocument(DocumentSnapshot doc) async {
    
    List<MenuItem> menuItems = [];
    List<MenuItem> topDishes = [];

    for (var menuDoc in (await doc.reference.collection('menu').get()).docs) {
      menuItems.add(MenuItem(name: menuDoc['name'], price: menuDoc['price'], dishId: menuDoc['dishId']));
     }

    for (var menuDoc in (await doc.reference.collection('best_dishes').get()).docs) {
      topDishes.add(MenuItem(name: menuDoc['name'], price: menuDoc['price'], dishId: menuDoc['dishId']));
    }

    return Restaurant(
      name: doc['name'],
      location: doc['location'],
      menuView: menuItems,
      topDishes: topDishes,
    );
  }

  static Future<List<Restaurant>> fetchRestaurants() async {
    //DateTime start = DateTime.now();
    List<Restaurant> restaurants = [];
    QuerySnapshot restaurantQuery = await FirebaseFirestore.instance.collection('restaurants').get();
    for (var restaurantDoc in restaurantQuery.docs) {
      restaurants.add(await Restaurant.fromDocument(restaurantDoc));
    }
    //print(DateTime.now().difference(start).inMilliseconds);
    return restaurants;
  }
}