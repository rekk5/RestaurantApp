import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/menu_item.dart';
import 'package:kandi/classes/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantPage extends StatefulWidget {
   const RestaurantPage({super.key});

    @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  List<Restaurant> restaurants =[];

  late Future<List<Restaurant>> restaurantFuture;
  

    

    @override
      void initState() {
        super.initState();
        restaurantFuture = _getInitialInfo();

    }

    Future<List<Restaurant>> _getInitialInfo() async {
      restaurants = await Restaurant.fetchRestaurants();
      return restaurants;
    }

    

  
  // a f
  
  bool foodItemClicked = false;
  FoodItem clickedFoodItem = FoodItem.empty();

  bool menuCLicked = false;
  int clickedMenuIndex = 0;

  List<MenuItem> clickedMenu = [];

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: restaurantFuture,
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
                    //height: 200,
                    child: _restaurantView()
                    )
                ),
                if (menuCLicked) ... [
                  Positioned(
                    top: 10,
                    child: _restaurantFullMenuView(context)
                  )
                ],
                if (foodItemClicked) ... [
                  Positioned(
                    top: 10,
                    child: clickedItemView()
                  )
                ],
                
              ],
            );
          }
        },
      ),
    );
  }

  Container _restaurantFullMenuView(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - 20,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${restaurants[clickedMenuIndex].name} menu'),
                // Container(
                //   height: 20,
                //   width: 20,
                //   decoration: BoxDecoration(
                //     color: Colors.black
                    
                //   ),
                // ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      menuCLicked = false;
                    });
                  },
                  icon: Icon(Icons.close)
                ),
            
            
              ],
            ),
          ),
          SizedBox(height: 25,),
          Expanded(
            child: ListView.builder(
              itemCount: restaurants[clickedMenuIndex].menuView.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (menuContext, menuIndex) {
                return GestureDetector(
                  onTap: () async {
                    FoodItem foodfoodItemToSet = await FoodItem.getClickedFoodItemFromFirebase2(restaurants[clickedMenuIndex].menuView[menuIndex].name, restaurants[clickedMenuIndex].menuView[menuIndex].price, restaurants[clickedMenuIndex].menuView[menuIndex].dishId);
                    
                    setState(() {
                      foodItemClicked = true;
                      // clickedFoodItem = restaurants[index].menu[menuIndex];
                      clickedFoodItem = foodfoodItemToSet;
                      
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
                          restaurants[clickedMenuIndex].menuView[menuIndex].name
                        ),
                        Text(
                          'Price ${restaurants[clickedMenuIndex].menuView[menuIndex].price}€' 
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  ListView _restaurantView() {
    return ListView.builder(
      itemCount: restaurants.length,
      scrollDirection: Axis.vertical, // Make the list scroll horizontally
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.topLeft,
          height: 170,
          margin: const EdgeInsets.all(8),// Set the width to the screen width
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 150, child: Text('${restaurants[index].name}')),
                    Text('Best Dishes'),
                  ],
                ),
                Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: 80,
                              child: Column(
                                children: [
                                  
                                  
                                  Text(
                                    '${restaurants[index].location}',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  menuCLicked = !menuCLicked;
                                  clickedMenuIndex = index;
                                });
                              },
                              style: ButtonStyle(
                                
                              ),
                              child: Text('Menu')
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _restaurantMenu(index),
                      ),
                    ],
                  ),
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
      itemCount: restaurants[index].topDishes.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (menuContext, menuIndex) {
        return GestureDetector(
          onTap: () async {
            FoodItem foodfoodItemToSet = await FoodItem.getClickedFoodItemFromFirebase2(restaurants[index].topDishes[menuIndex].name, restaurants[index].topDishes[menuIndex].price, restaurants[index].topDishes[menuIndex].dishId);
            
            setState(() {
              foodItemClicked = true;
              // clickedFoodItem = restaurants[index].menu[menuIndex];
              clickedFoodItem = foodfoodItemToSet;
              
            });
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 100,
            width: 200,
            color: Colors.red,
            child: Column(
              children: [
                // Text(
                //   restaurants[index].menu[menuIndex].name
                // ),
                // Text(
                //   '${restaurants[index].menu[menuIndex].totalCalories} kcal'
                // ),
                // Text(
                //   'Price ${restaurants[index].menu[menuIndex].price}€' 
                // ),
                Text(
                  restaurants[index].topDishes[menuIndex].name
                ),
                Text(
                  'Price ${restaurants[index].topDishes[menuIndex].price}€' 
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
            Text(
              'Nutri-Score ${clickedFoodItem.nutriScore}' 
            ),
            
          ],
        ),
      
      ),
    );
  }

  



  // Future<List<MenuItem>> getClickedMenu(String restaurantName) async{
  //   List<MenuItem> menuItems = [];
    
  //   return menuItems;
  // }



}