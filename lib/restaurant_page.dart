import 'package:flutter/material.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/restaurant.dart';

class RestaurantPage extends StatefulWidget {
   const RestaurantPage({super.key});

    @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
    List<Restaurant> restaurants = [];

    @override
      void initState() {
        super.initState();
      _getInitialInfo();
    }

    Future<List<Restaurant>> _getInitialInfo() async {
      restaurants = await Restaurant.fetchRestaurants();
      return restaurants;
    }


  // a f
  bool foodItemClicked = false;
  FoodItem clickedFoodItem = FoodItem.empty();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _getInitialInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            restaurants = snapshot.data ?? [];
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: Container(
                    height: 200,
                    child: _restaurantView()
                    )
                ),
                if (foodItemClicked) ... [
                  Positioned(
                    top: 10,
                    child: clickedItemView()
                  )
                ]
              ],
            );
          }
        },
      ),
    );
  }

  ListView _restaurantView() {
    return ListView.builder(
      itemCount: restaurants.length,
      scrollDirection: Axis.horizontal, // Make the list scroll horizontally
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          margin: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width, // Set the width to the screen width
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${restaurants[index].name}  |  ${restaurants[index].location}'
                ),
                Expanded(
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