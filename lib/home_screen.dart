import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/restaurant_page.dart';
import 'gender_metrics_page.dart'; // Import your GenderMetricsPage file here
import 'feed_back.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Recommendations',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 140,
                  child: ListView.separated(
                    itemCount: testMenu.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(width: 20,),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: foodHealthinessColors[testMenu[index].healthRating].toColor(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                testMenu[index].name,
                              ),
                            ),
                            SizedBox(height: 15,),
                            Text(
                              testMenu[index].totalCalories.toString() + ' kcal',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 107, 102, 102)
                              ),
                            )
                          
                          ],
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
                  MaterialPageRoute(builder: (context) => RestaurantPage()),
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
      ),
    );
  }
}
