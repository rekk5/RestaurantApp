import 'package:flutter/material.dart';
import 'package:kandi/classes/food_item.dart';
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
  List<FoodItem> testMenu = [];

  // basic colors for boxes displaying food items. Box color associated with food item healthiness
  List<HSVColor> foodHealthinessColors = [];

  HSVColor red = HSVColor.fromColor(Colors.red);

  HSVColor orange = HSVColor.fromColor(Colors.orange);

  HSVColor yellow = HSVColor.fromColor(Colors.yellow);

  HSVColor green = HSVColor.fromColor(Colors.green);

  void _getInitialInfo(){
    testMenu = FoodItem.getTestMenu();
    foodHealthinessColors.add(green);
    foodHealthinessColors.add(yellow);
    foodHealthinessColors.add(orange);
    foodHealthinessColors.add(red);
    
  }

  bool recommendedFoodItemClicked = false;

  FoodItem clickedFoodItem = FoodItem.getTestItem();

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'Recommendations',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        itemCount: testMenu.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15
                        ),
                        separatorBuilder: (context, index) => const SizedBox(width: 20,),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                recommendedFoodItemClicked = true;
                                clickedFoodItem = testMenu[index];
                              });
                            },
                            onTapCancel: () => print('cancel'),
                            onDoubleTap: () =>  print(recommendedFoodItemClicked),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: foodHealthinessColors[testMenu[index].healthRating].toColor(),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: Flexible(
                                      child: Text(
                                        testMenu[index].name,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  Text(
                                    '${testMenu[index].totalCalories} kcal',
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
                const SizedBox(height: 40,),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the map screen (Not implemented yet)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Map screen is not implemented yet.'),
                      ),
                    );
                  },
                  child: const Text('Map'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the database screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RestaurantPage()),
                    );
                  },
                  child: const Text('Database'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the GenderMetricsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GenderMetricsPage()),
                    );
                  },
                  child: const Text('Profile'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the FeedbackPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FeedbackPage()),
                    );
                  },
                  child: const Text('Feedback'),
                ),
              ],
            ),
            if (recommendedFoodItemClicked) ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    recommendedFoodItemClicked = false;
                  });
                },
                child: Container(
                  height: 400,
                  width: 400,
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
                        'protein ${clickedFoodItem.protein}'
                      ),
                      Text(
                        'fat ${clickedFoodItem.fat}g of which saturates ${clickedFoodItem.saturatedFat}g' 
                      ),
                      Text(
                        'carbohydrates ${clickedFoodItem.carbohydrates}g of which sugar ${clickedFoodItem.sugar}g' 
                      ),
                    ],
                  ),
                
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
