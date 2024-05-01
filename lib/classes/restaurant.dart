import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/menu_item.dart';

class Restaurant {
  String name;
  String location;
  //List<FoodItem> menu;
  List<MenuItem> menuView;
  List<MenuItem> topDishes;

  Restaurant({
    required this.name,
    required this.location,
    //required this.menu,
    required this.menuView,
    required this.topDishes,
  });

  static Future<Restaurant> fromDocument(DocumentSnapshot doc) async {
    // List<FoodItem> menu = [];
    // for (var menuDoc in (await doc.reference.collection('menu').get()).docs) {
    //   DocumentSnapshot dishDoc = await FirebaseFirestore.instance.collection('dishes').doc(menuDoc['dishId']).get();
    //   String dishName = dishDoc['name'];
    //   print(dishName);
    //   double totalCalories = 0;
    //   Map<String, dynamic> fineliData = {};
    //   for (var fineliId in dishDoc['fineliId']) {
    //     DocumentSnapshot fineliDoc = await FirebaseFirestore.instance.collection('fineli_kaikki').doc(fineliId).get();
    //     fineliData = fineliDoc.data() as Map<String, dynamic>;
    //     double portionSize = double.parse(fineliData['medium portion'].replaceAll(",", "."));
    //     totalCalories += (fineliData['calories'] * portionSize) / 100;
    //   }
    //   menu = FoodItem.getTestMenu();
    //   //menu.add(FoodItem.fromDocument(menuDoc, dishName, totalCalories, fineliData));
    // }
    List<MenuItem> menuItems = [];
    List<MenuItem> topDishes = [];

    for (var menuDoc in (await doc.reference.collection('menu').get()).docs) {
      menuItems.add(MenuItem(name: menuDoc['dishId'], price: menuDoc['price'], dishId: menuDoc['dishId']));
     }

    for (var menuDoc in (await doc.reference.collection('best_dishes').get()).docs) {
      topDishes.add(MenuItem(name: menuDoc['name'], price: menuDoc['price'], dishId: menuDoc['dishId']));
    }

    //menu = FoodItem.getTestMenu();
    return Restaurant(
      name: doc['name'],
      location: doc['location'],
      //menu: menu,
      menuView: menuItems,
      topDishes: topDishes,
    );
  }

  static Future<List<Restaurant>> fetchRestaurants() async {
    DateTime start = DateTime.now();
    List<Restaurant> restaurants = [];
    QuerySnapshot restaurantQuery = await FirebaseFirestore.instance.collection('restaurants').get();
    for (var restaurantDoc in restaurantQuery.docs) {
      restaurants.add(await Restaurant.fromDocument(restaurantDoc));
    }
    print(DateTime.now().difference(start).inMilliseconds);
    return restaurants;
  }
}