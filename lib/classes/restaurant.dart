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

  static List<Restaurant> getTestRestaurantList(){
    List<Restaurant> restaurantList = [];

    restaurantList.add(Restaurant(
      name: 'Test Restaurant',
      foodChain: 'Tests_FoodChain',
      address: 'Testitie 1',
      menu: FoodItem.getTestMenu()
      ));

    restaurantList.add(Restaurant(
      name: 'Test Restaurant 2',
      foodChain: 'Tests_FoodChain2',
      address: 'Testitie 2',
      menu: FoodItem.getTestMenu()
      ));

    restaurantList.add(Restaurant(
      name: 'Test Restaurant 3',
      foodChain: 'Tests_FoodChain3',
      address: 'Testitie 3',
      menu: FoodItem.getTestMenu()
      ));

    restaurantList.add(Restaurant(
      name: 'Test Restaurant 4',
      foodChain: 'Tests_FoodChain4',
      address: 'Testitie 4',
      menu: FoodItem.getTestMenu()
      ));

    restaurantList.add(Restaurant(
      name: 'Test Restaurant 5',
      foodChain: 'Tests_FoodChain5',
      address: 'Testitie 5',
      menu: FoodItem.getTestMenu()
      ));


    return restaurantList;
  }
  
}