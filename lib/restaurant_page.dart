import 'package:flutter/material.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/menu_item.dart';
import 'package:kandi/classes/restaurant.dart';
import 'package:kandi/classes/restaurant_data.dart';
import 'package:provider/provider.dart';
import 'package:rate_in_stars/rate_in_stars.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class RestaurantPage extends StatefulWidget {
   const RestaurantPage({super.key});

    @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>  {

  List<Restaurant> _restaurants =[];

    @override
      void initState() {
        super.initState();
    }

  
  bool _foodItemClicked = false;
  FoodItem _clickedFoodItem = FoodItem.empty();

  bool _menuCLicked = false;
  int _clickedMenuIndex = 0;

 
  @override
  Widget build(BuildContext context) {
    _restaurants = Provider.of<RestaurantData>(context).restaurants;
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
              child: _restaurantsView()
            )
          ),
          if (_menuCLicked) ... [
            Positioned(
              top: 10,
              child: _restaurantFullMenuView(context)
            )
          ],
          if (_foodItemClicked) ... [
            Positioned(
              top: 10,
              child: _clickedItemView()
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
                Text('${_restaurants[_clickedMenuIndex].name} menu'),
                _closeFullMenuViewButton(),
              ],
            ),
          ),
          const SizedBox(height: 25,),
          Expanded(
            child: ListView.builder(
              itemCount: _restaurants[_clickedMenuIndex].menuView.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (menuContext, menuIndex) {
                return _restaurantMenuItemBox(menuIndex);
              }
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _restaurantMenuItemBox(int menuIndex) {
    return GestureDetector(
      onTap: () async {
        FoodItem foodfoodItemToSet = await FoodItem.getClickedFoodItemFromFirebase2(_restaurants[_clickedMenuIndex].menuView[menuIndex].name, _restaurants[_clickedMenuIndex].menuView[menuIndex].price, _restaurants[_clickedMenuIndex].menuView[menuIndex].dishId);
        
        setState(() {
          _foodItemClicked = true;
          _clickedFoodItem = foodfoodItemToSet;
          
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
              _restaurants[_clickedMenuIndex].menuView[menuIndex].name
            ),
            Text(
              'Price ${_restaurants[_clickedMenuIndex].menuView[menuIndex].price}€' 
            ),
          ],
        ),
      ),
    );
  }

  IconButton _closeFullMenuViewButton() {
    return IconButton(
      onPressed: (){
        setState(() {
          _menuCLicked = false;
        });
      },
      icon: const Icon(Icons.close)
    );
  }

  ListView _restaurantsView() {
    return ListView.builder(
      itemCount: _restaurants.length,
      scrollDirection: Axis.vertical, 
      itemBuilder: (context, index) {
        return _singleRestaurantBox(index, context);
      },
    );
  }

  Container _singleRestaurantBox(int index, BuildContext context) {
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
                SizedBox(width: 150, child: Text(_restaurants[index].name)),
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
                        _restaurantLocationText(index),
                        _restaurantRatingStars(index),
                        _restaurantMenuButton(index),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _restaurantBestDishes(index),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _restaurantLocationText(int index) {
    return Container(
      alignment: Alignment.topLeft,
      width: 80,
      child: Column(
        children: [
          Text(
            _restaurants[index].location,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _restaurantMenuButton(int index) {
    return ElevatedButton(
      onPressed: (){
        setState(() {
          _menuCLicked = !_menuCLicked;
          _clickedMenuIndex = index;
        });
      },
      style: const ButtonStyle(
        
      ),
      child: const Text('Menu')
      );
  }

  RatingBar _restaurantRatingStars(int index) {
    return RatingBar.builder(
      initialRating: _restaurants[index].rating,
      allowHalfRating: true,
      itemSize: 20,
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber, ),
      onRatingUpdate: (value) => (),
      ignoreGestures: true,
      
    );
  }

  ListView _restaurantBestDishes(int index) {
    return ListView.builder(
      itemCount: _restaurants[index].topDishes.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (menuContext, menuIndex) {
        return _bestDishBox(index, menuIndex);
      }
    );
  }

  GestureDetector _bestDishBox(int index, int menuIndex) {
    return GestureDetector(
      onTap: () async {
        FoodItem foodfoodItemToSet = await FoodItem.getClickedFoodItemFromFirebase2(_restaurants[index].topDishes[menuIndex].name, _restaurants[index].topDishes[menuIndex].price, _restaurants[index].topDishes[menuIndex].dishId);
        
        setState(() {
          _foodItemClicked = true;
          _clickedFoodItem = foodfoodItemToSet;
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
              _restaurants[index].topDishes[menuIndex].name
            ),
            Text(
              'Price ${_restaurants[index].topDishes[menuIndex].price}€' 
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _clickedItemView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _foodItemClicked = false;
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
                _clickedFoodItem.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 10,),
            const Text('per 100 grams', style: TextStyle(fontSize: 10),),
            Text(
              '${_clickedFoodItem.calories.toStringAsFixed(1)} kcal'
            ),
            Text(
              '${_clickedFoodItem.protein.toStringAsFixed(1)} grams of Protrein'
            ),
            Text(
              'Fat: ${_clickedFoodItem.fat.toStringAsFixed(1)} grams of which saturates ${_clickedFoodItem.saturatedFat.toStringAsFixed(1)}g' 
            ),
            Text(
              'Carbohydrates: ${_clickedFoodItem.carbohydrates.toStringAsFixed(1)}g of which sugar ${_clickedFoodItem.sugar.toStringAsFixed(1)}g' 
            ),
            Text(
              'Fiber ${_clickedFoodItem.fiber.toStringAsFixed(1)}g' 
            ),
            Text(
              'Estiamted portion: ${_clickedFoodItem.weight}g'
              ),
            const SizedBox(height: 20,),
            FoodItem.getNutriScoreGraphic(_clickedFoodItem.nutriScore),
            const SizedBox(height: 15,),
            Text(
              '${_clickedFoodItem.price}€' ,
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