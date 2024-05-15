import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kandi/classes/menu_item.dart';


class Recommendation{
  List<MenuItem> recommededItems;
  List<String> calories;

  Recommendation({
    required this.recommededItems,
    required this.calories
  });

  static Future<Recommendation> getRecommendations() async{
    List<MenuItem> recommendedMenu = [];
    List<String> calories = [];
    QuerySnapshot recommendationQuery = await FirebaseFirestore.instance.collection('recommendedDishes').doc('types').collection('test').get();
    for (var menuDoc in recommendationQuery.docs){
      print(menuDoc['name']);
      recommendedMenu.add(MenuItem(name: menuDoc['name'], price: menuDoc['price'], dishId: menuDoc['dishId']));
      calories.add(menuDoc['calories']);
    }

    Recommendation recommendation = Recommendation(recommededItems: recommendedMenu, calories: calories);
    return recommendation;
  }
}