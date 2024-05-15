import 'package:flutter/material.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/menu_item.dart';
import 'package:kandi/classes/recommendation.dart';
import 'package:kandi/classes/restaurant.dart';
import 'package:kandi/restaurant_page.dart';
import 'gender_metrics_page.dart'; // Import your GenderMetricsPage file here
import 'feed_back.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // initial info
  List<Restaurant> restaurants = [];
  List<FoodItem> topDishes = [];

  late Future<Recommendation> recommendationFuture;
  
  late Recommendation recommendation;

  // basic colors for boxes displaying food items. Box color associated with food item healthiness
  List<HSVColor> foodHealthinessColors = [];

  HSVColor red = HSVColor.fromColor(Colors.red);
  HSVColor orange = HSVColor.fromColor(Colors.orange);
  HSVColor yellow = HSVColor.fromColor(Colors.yellow);
  HSVColor green = HSVColor.fromColor(Colors.green);
  

  @override
  void initState() {
    super.initState();
    recommendationFuture = _getInitialInfo();
  }

  Future<Recommendation> _getInitialInfo() async {
    //List<Restaurant> fetchedRestaurants = await Restaurant.fetchRestaurants();
    List<FoodItem> allDishes = FoodItem.getTestMenu();
  
      // Get all dishes from all restaurants
    // for (var restaurant in fetchedRestaurants) {
    //   allDishes.addAll(restaurant.menu);
    // }
    // Sort the dishes based on their health rating in descending order
    allDishes.sort((a, b) => b.healthRating.compareTo(a.healthRating));
    // Take the top 5 dishes
    topDishes = allDishes.take(5).toList();
    foodHealthinessColors.add(green);
    foodHealthinessColors.add(yellow);
    foodHealthinessColors.add(orange);
    foodHealthinessColors.add(red);

    recommendation = await Recommendation.getRecommendations();

    return recommendation;
  }

  bool recommendedFoodItemClicked = false;

  FoodItem clickedFoodItem = FoodItem.empty();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: recommendationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading spinner while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if there's an error
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home Screen'),
            ),
            body: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _recommendationList(),
                        const SizedBox(height: 20),
                        _databaseButton(context),
                        const SizedBox(height: 20),
                        _userMetricsButton(context),
                        const SizedBox(height: 20),
                        _feedbackButton(context),
                      ],
                    ),
                  ),
                  if (recommendedFoodItemClicked) ...[
                    Positioned(
                      top: 10,
                      child: clickedItemView()
                      )
                  ]
                ],
              ),
            ),
          );
        }
      },
    );
  }

  ElevatedButton _feedbackButton(BuildContext context) {
    return ElevatedButton(
                  onPressed: () {
                    // Navigate to the FeedbackPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackPage()),
                    );
                  },
                  child: const Text('Feedback'),
                );
  }

  ElevatedButton _userMetricsButton(BuildContext context) {
    return ElevatedButton(
                  onPressed: () {
                    // Navigate to the GenderMetricsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GenderMetricsPage()),
                    );
                  },
                  child: const Text('Profile'),
                );
  }

  ElevatedButton _databaseButton(BuildContext context) {
    return ElevatedButton(
                  onPressed: () {
                    // Navigate to the database screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RestaurantPage()),
                    );
                  },
                  child: const Text('Restaurants'),
                );
  }

  GestureDetector clickedItemView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          recommendedFoodItemClicked = false;
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
              'protein ${clickedFoodItem.protein}'
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
              'Nutri-Score: ${clickedFoodItem.nutriScore}' 
            ),
          ],
        ),
      
      ),
    );
  }

 Container _recommendationList() {
    return Container(
      height: 350, // Set the height to a specific value
      child: Column(
        children: [
          const Text(
            'Top Dishes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: recommendation.recommededItems.length,
              itemBuilder: (context, index) {
                MenuItem menuItem = recommendation.recommededItems[index];
                return GestureDetector(
                  onTap: () async {
                    FoodItem foodItemToSet = await FoodItem.getClickedFoodItemFromFirebase2(menuItem.name, menuItem.price, menuItem.dishId);
                    setState(() {
                      recommendedFoodItemClicked = true;
                      clickedFoodItem = foodItemToSet;
                    });
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.green,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            menuItem.name,
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Text(
                          '${double.parse(recommendation.calories[index]).round()} kcal' ,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 107, 102, 102)
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

