import 'package:flutter/material.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/menu_item.dart';
import 'package:kandi/classes/restaurant.dart';
import 'package:kandi/classes/restaurant_data.dart';
import 'package:provider/provider.dart';

class RestaurantPage extends StatefulWidget {
   const RestaurantPage({super.key});

    @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>  {

  List<Restaurant> restaurants =[];

    @override
      void initState() {
        super.initState();
    }

  
  bool foodItemClicked = false;
  FoodItem clickedFoodItem = FoodItem.empty();

  bool menuCLicked = false;
  int clickedMenuIndex = 0;

  List<MenuItem> clickedMenu = [];

 
  @override
  Widget build(BuildContext context) {
    restaurants = Provider.of<RestaurantData>(context).restaurants;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
      ),
      body:  Stack(
              alignment: Alignment.center,
              children: [
                if(!Provider.of<RestaurantData>(context).fetched)
                  const Center(child: CircularProgressIndicator()),

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
            )
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
                IconButton(
                  onPressed: (){
                    setState(() {
                      menuCLicked = false;
                    });
                  },
                  icon: const Icon(Icons.close)
                ),
              ],
            ),
          ),
          const SizedBox(height: 25,),
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
      scrollDirection: Axis.vertical, 
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.topLeft,
          height: 170,
          margin: const EdgeInsets.all(8),
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 150, child: Text(restaurants[index].name)),
                    const Text('Best Dishes'),
                  ],
                ),
                SizedBox(
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
                                    restaurants[index].location,
                                    style: const TextStyle(
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
                              style: const ButtonStyle(
                                
                              ),
                              child: const Text('Menu')
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
        height: 400,
        width: 300,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 224, 223, 189),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                clickedFoodItem.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            

            const SizedBox(height: 10,),
            const Text('per 100 grams', style: TextStyle(fontSize: 10),),
            Text(
              '${clickedFoodItem.calories.toStringAsFixed(1)} kcal'
            ),
            Text(
              '${clickedFoodItem.protein.toStringAsFixed(1)} grams of Protrein'
            ),
            Text(
              'Fat: ${clickedFoodItem.fat.toStringAsFixed(1)} grams of which saturates ${clickedFoodItem.saturatedFat.toStringAsFixed(1)}g' 
            ),
            Text(
              'Carbohydrates: ${clickedFoodItem.carbohydrates.toStringAsFixed(1)}g of which sugar ${clickedFoodItem.sugar.toStringAsFixed(1)}g' 
            ),
            Text(
              'Fiber ${clickedFoodItem.fiber.toStringAsFixed(1)}g' 
            ),
            Text(
              'Estiamted portion: ${clickedFoodItem.weight}g'
              ),
            const SizedBox(height: 20,),
            FoodItem.getNutriScoreGraphic(clickedFoodItem.nutriScore),
            const SizedBox(height: 15,),
            Text(
              '${clickedFoodItem.price}€' ,
              style: const TextStyle(
                fontSize: 30
              ),
            ),
          ],
        ),
      
      ),
    );
  }

}