import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kandi/classes/food_item.dart';
import 'package:kandi/classes/recommendation.dart';
import 'package:kandi/restaurant_page.dart';
import 'gender_metrics_page.dart'; // Import your GenderMetricsPage file here
import 'feed_back.dart';
import 'nutriscore_graphic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // initialize recommendation
  late Future<Recommendation> _recommendationFuture;
  
  late Recommendation _recommendation;

  @override
  void initState() {
    super.initState();
    _recommendationFuture = _getInitialInfo();
  }

  // fetches recommendations
  Future<Recommendation> _getInitialInfo() async {

    _recommendation = await Recommendation.getRecommendations();

    return _recommendation;
  }

  // if true shows logout button if true, changed by clicking user icon
  bool _showLogout = false;
  // if true shows information about recommendations, changed by clicking info icon 
  bool _showRecommendationInfo = false;
  // if true shows information graphic on clicked FoodItem, changed by clicking one of recommendations
  bool _recommendedFoodItemClicked = false;
  // FoodItem to be shown initialized as empty, changed to food item that was clicked
  FoodItem _clickedFoodItem = FoodItem.empty();

  // operation of the sctack based on booleans above
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
    _userProfileIconButton()
        ],
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: _mainView(context),
            ),
              if (_showRecommendationInfo) ...[
              _recommendationInfo()
            ],
            if (_recommendedFoodItemClicked) ...[
              Positioned(
                top: 10,
                child: _clickedItemView()
                )
            ],
            if (_showLogout) ...[
            Positioned(
              top: 0,
              right: 10,
              child: Container(
                height: 35,
                width: 100,
                color: const Color.fromARGB(255, 88, 88, 88),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.popAndPushNamed(context, '/login');
                      },
                      icon: const Icon(Icons.logout),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                    )
              
                  ],
                ),
              ),
            )
            ],
          ],
        ),
      ),
    );

  }

  Column _mainView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            _aboveRecommandationsBar(context),
            const SizedBox(height: 15),
            FutureBuilder(
              future: _recommendationFuture,
              builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 320, child: Center(child: CircularProgressIndicator()));
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
    );
  }

  Row _aboveRecommandationsBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoButton(context),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
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
    );
  }

  IconButton _userProfileIconButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _showLogout = !_showLogout;
        });
      },
      icon: const Icon(Icons.account_circle),
      iconSize: 53,
    );
  }

  Positioned _recommendationInfo() {
    return Positioned(
      top: 10,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showRecommendationInfo = !_showRecommendationInfo;
          });
        },
        child: Container(
          height: 250,
          width: 250,
          color: const Color.fromARGB(255, 124, 209, 248),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Recommended dishes are based on your user profile information and sorted by Nutri-Score to promote healthy eating. After changing food preferences, use the refresh button to get improved recommendations."
            ),
          ),
        ),
      )
      );
  }

      IconButton _infoButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Navigate to the FeedbackPage
        setState(() {
          _showRecommendationInfo = !_showRecommendationInfo;
        });
      },
      icon: const Icon(Icons.info_outline),
    );
  }

    IconButton _refreshButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Navigate to the FeedbackPage
        setState(() {
          _recommendationFuture = _getInitialInfo();
        });
      },
      icon: const Icon(Icons.refresh),
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

  GestureDetector _clickedItemView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _recommendedFoodItemClicked = false;
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
            Text(
              _clickedFoodItem.restaurant
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
              'Salt ${_clickedFoodItem.salt.toStringAsFixed(1)}mg' 
            ),

            Text('Estiamted portion: ${_clickedFoodItem.weight}g'),
            const SizedBox(height: 20,),
            getNutriScoreGraphic(_clickedFoodItem.nutriScore),
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

 SizedBox _recommendationList() {
    return SizedBox(
      height: 320, // Set the height to a specific value
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _recommendation.recommendedItems.length,
              itemBuilder: (context, index) {
                FoodItem recommendedFoodItem = _recommendation.recommendedItems[index];
                return _recommededFoodItemBox(recommendedFoodItem, index);
              },
            ),
          )
        ],
      ),
    );
  }

  GestureDetector _recommededFoodItemBox(FoodItem recommendedFoodItem, int index) {
    return GestureDetector(
      onTap: () {
      FoodItem foodItemToSet = recommendedFoodItem;
        setState(() {
          _recommendedFoodItemClicked = true;
          _clickedFoodItem = foodItemToSet;
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
                  recommendedFoodItem.name,
                ),
              ),
              Text(
                _recommendation.recommendedItems[index].restaurant ,
                style: const TextStyle(
                  fontSize: 13,
                  
                ),
              ),
              
              Text(
                '${_recommendation.recommendedItems[index].calories.round()} kcal' ,
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
  }
}