import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
      ),
      body: _restaurantView(),
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
        return Container(
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
              )
            ],
          ),
        );
      }
    );
  }

}