import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/restaurant.dart';

class RestaurantPage extends StatefulWidget {
   const RestaurantPage({super.key});

    @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
    List<Restaurant> restaurants = [];

   void _getInitialInfo(){
    restaurants = Restaurant.getTestRestaurantList();
   }


  // a f
  bool foodItemClicked = false;
  FoodItem clickedFoodItem = FoodItem.getEmptyFoodItem();

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: _restaurantView()
          ),
          if (foodItemClicked) ... [
            Positioned(
              top: 10,
              child: clickedItemView()
            )
          ]
        ],
      ),
    );
  }

  ListView _restaurantView() {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          height: 160,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${restaurants[index].name}  |  ${restaurants[index].address}'
                  ),
                  SizedBox(
                  height: 120,
                  child: _restaurantMenu(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView _restaurantMenu(int index) {
    return ListView.builder(
      itemCount: restaurants[index].menu.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (menuContext, menuIndex) {
        return GestureDetector(
          onTap: () {
            setState(() {
              foodItemClicked = true;
              clickedFoodItem = restaurants[index].menu[menuIndex];
            });
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 100,
            width: 200,
            color: Colors.red,
            child: Column(
              children: [
                Text(
                  restaurants[index].menu[menuIndex].name
                ),
                Text(
                  '${restaurants[index].menu[menuIndex].totalCalories} kcal'
                ),
                Text(
                  'Price ${restaurants[index].menu[menuIndex].price}€' 
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  GestureDetector clickedItemView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          foodItemClicked = false;
        });
      },
      child: Container(
        height: 300,
        width: 300,
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: [
            Text(
              clickedFoodItem.name
            ),
            Text(
              'Restaurant: ${clickedFoodItem.restaurant}',
            ),
            Text(
              '${clickedFoodItem.calories} kcal',
            ),
            Text(
              'protein ${clickedFoodItem.protein}g'
            ),
            Text(
              'fat ${clickedFoodItem.fat}g of which saturates ${clickedFoodItem.saturatedFat}g' 
            ),
            Text(
              'carbohydrates ${clickedFoodItem.carbohydrates}g of which sugar ${clickedFoodItem.sugar}g' 
            ),
            Text(
              'Fiber ${clickedFoodItem.fiber}g' 
            ),
            Text(
              'Price ${clickedFoodItem.price}€' 
            ),
            
          ],
        ),
      
      ),
    );
  }

}