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

  bool showInfo = false;

  bool recommendedFoodItemClicked = false;

  FoodItem clickedFoodItem = FoodItem.empty();

  @override
  Widget build(BuildContext context) {
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
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _infoButton(context),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    'Top Dishes For You',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                _refreshButton(context)
                              ],
                            ),
                            const SizedBox(height: 15),
                            FutureBuilder(
                              future: recommendationFuture,
                              builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return SizedBox(height: 320, child: const Center(child: CircularProgressIndicator()));
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else {
                                  return  _recommendationList();
                                  }
                              }
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _databaseButton(context),
                        const SizedBox(height: 20),
                        _userMetricsButton(context),
                        const SizedBox(height: 20),
                        _feedbackButton(context),
                      ],
                    ),
                  ),
                   if (showInfo) ...[
                    Positioned(
                      top: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showInfo = !showInfo;
                          });
                        },
                        child: Container(
                          height: 250,
                          width: 250,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Recommended dishes are based on your user profile information and sorted by Nutri-Score to promote healthy eating. After changing food preferences, use the refresh button to get improved recommendations."
                            ),
                          ),
                        ),
                      )
                      )
                  ],
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

      IconButton _infoButton(BuildContext context) {
    return IconButton(
                  onPressed: () {
                    // Navigate to the FeedbackPage
                    setState(() {
                      showInfo = !showInfo;
                    });
                  },
                  icon: Icon(Icons.info_outline),
                );
  }

    IconButton _refreshButton(BuildContext context) {
    return IconButton(
                  onPressed: () {
                    // Navigate to the FeedbackPage
                    setState(() {
                      recommendationFuture = _getInitialInfo();
                    });
                  },
                  icon: Icon(Icons.refresh),
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
      height: 320, // Set the height to a specific value
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: recommendation.recommendedItemsFull.length,
              itemBuilder: (context, index) {
                FoodItem menuItem = recommendation.recommendedItemsFull[index];
                return GestureDetector(
                  onTap: () async {
                  //  FoodItem foodItemToSet = await FoodItem.getClickedFoodItemFromFirebase2(menuItem.name, menuItem.price, menuItem.dishId);
                  FoodItem foodItemToSet = menuItem;
                    setState(() {
                      recommendedFoodItemClicked = true;
                      clickedFoodItem = foodItemToSet;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.green,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Text(
                              menuItem.name,
                            ),
                          ),
                          Text(
                            recommendation.recommendedItemsFull[index].restaurant ,
                            style: const TextStyle(
                              fontSize: 13,
                              
                            ),
                          ),
                          
                          
                          Text(
                            '${recommendation.recommendedItemsFull[index].calories.round()} kcal' ,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 107, 102, 102)
                            ),
                          )
                        ,
                        const SizedBox(height: 15,),
                        ],
                      ),
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

