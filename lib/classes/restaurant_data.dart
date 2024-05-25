import 'package:flutter/material.dart';
import 'package:kandi/classes/restaurant.dart';

class RestaurantData with ChangeNotifier{

  // The list of restaurants 
  List<Restaurant> _restaurants = [];

  // Tells if restaurants have already been fertched
  bool _fetched = false;

  // Calls the fetchRestaurants() function to fetch restaurants from Firebase (only if restaurants have not been fetched already)
  // and notifies listeners after they haven been fetched
  Future<void> fetchData() async {
    if (!_fetched){
      _restaurants = await Restaurant.fetchRestaurants();
      _fetched = true;
      notifyListeners();
    }
  
  }
  // returns the list of restaurants and calls to fetchData() if restaurants is empty;
  List<Restaurant> get restaurants{
    if (_restaurants.isEmpty){
      fetchData();
    }
    return _restaurants;
    
  }
  // returns bool to tell if restaurants have been fetched
  bool get fetched{
    return _fetched;
  }


}