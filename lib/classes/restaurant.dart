import 'package:kandi/classes/food_item.dart';

class Restaurant{
  
  String name;
  String foodChain;
  String address;
  List<FoodItem> menu;
  double longitude = 0;
  double lattutde = 0;




  Restaurant({
    required this.name,
    required this.foodChain,
    required this.address,
    required this.menu,
  });


  static Restaurant getTestRestaurant(){
    Restaurant testRestaurant = Restaurant(
      name: 'Test Restaurant',
      foodChain: 'Tests_FoodChain',
      address: 'Testitie 1',
      menu: FoodItem.getTestMenu()
      );
    return testRestaurant;
  }
  
}