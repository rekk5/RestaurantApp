import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodItem {
  String name;
  double totalCalories;
  double weight;
  double calories;
  double protein;
  double fat;
  double saturatedFat;
  double carbohydrates;
  double sugar;
  double fiber;
  String price;
  int healthRating;
  bool fullView = false;
  String nutriScore;
  String restaurant ;


  FoodItem.empty()
      : name = '',
        totalCalories = 0.0,
        weight = 0.0,
        calories = 0.0,
        protein = 0.0,
        fat = 0.0,
        saturatedFat = 0.0,
        carbohydrates = 0.0,
        sugar = 0.0,
        fiber = 0.0,
        price = "0,0",
        healthRating = 0,
        nutriScore = 'C',
        restaurant = "";
    
  FoodItem({
    required this.name,
    required this.totalCalories,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.saturatedFat,
    required this.carbohydrates,
    required this.sugar,
    required this.fiber,
    this.healthRating = 0,
    this.weight = 100,
    required this.price,
    required this.nutriScore,
    this.restaurant = ""

  });

  set itemRestaurant(String restaurant){
    this.restaurant = restaurant;
  }

  static Container getNutriScoreGraphic(String nutriScore){
    if(nutriScore == 'A'){
      return Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    const Text(
                      'NUTRI-SCORE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 108, 108, 108)
                      ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 75,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 3)
                            ),
                            child: const Center(child: Text('A', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.white),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                            ),
                            child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 247, 216, 43) ,
                            ),
                            child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                            ),
                            child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                 bottomRight: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('E', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          
                          
                        ],
                      )
                  
                  ],
                ),
              );
      }
      else if (nutriScore == 'B'){
        return  Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    const Text(
                      'NUTRI-SCORE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 108, 108, 108)
                      ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                 bottomLeft: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 75,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 247, 216, 43) ,
                            ),
                            child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                            ),
                            child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                 bottomRight: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('E', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          
                          
                        ],
                      )
                  
                  ],
                ),
              );
      }
      else if(nutriScore == 'C'){
        return Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    const Text(
                      'NUTRI-SCORE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 108, 108, 108)
                      ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                 bottomLeft: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                            ),
                            child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 75,
                            width: 45,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 247, 216, 43) ,
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                            ),
                            child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                 bottomRight: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('E', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          
                          
                        ],
                      )
                  
                  ],
                ),
              );
      }
      else if(nutriScore == 'D'){
        return Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    const Text(
                      'NUTRI-SCORE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 108, 108, 108)
                      ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                 bottomLeft: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                            ),
                            child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 247, 216, 43) ,
                            ),
                            child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 75,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.orange ,
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                 bottomRight: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('E', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          
                          
                        ],
                      )
                  
                  ],
                ),
              );
      }
      else{
        return Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    const Text(
                      'NUTRI-SCORE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 108, 108, 108)
                      ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                 bottomLeft: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                            ),
                            child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 247, 216, 43) ,
                            ),
                            child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                            ),
                            child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 75,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 3)
                            ),
                            child: const Center(child: Text('E', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.white),)),
                          ),
                          
                          
                        ],
                      )
                  
                  ],
                ),
              );
      }
  }
  


  static Future<FoodItem> getClickedFoodItemFromFirebase2(String dishName, String price, String dishId) async {
    DocumentSnapshot dishDoc = await FirebaseFirestore.instance.collection('dishes').doc(dishId).get();
    // String dishName = dishDoc['name'];
    // print(dishName);
    double totalCalories = double.parse(dishDoc['calories']) *  double.parse(dishDoc['weight'])/100;
    
    return FoodItem(
      name: dishName,
      totalCalories: totalCalories,
      calories: double.parse(dishDoc['calories']),
      protein: double.parse(dishDoc['protein']),
      fat: double.parse(dishDoc['fat']),
      saturatedFat: double.parse(dishDoc['saturated fat']),
      carbohydrates: double.parse(dishDoc['carbs']),
      sugar: double.parse(dishDoc['sugar']),
      fiber: double.parse(dishDoc['fiber']),
      price: price,
      weight: double.parse(dishDoc['weight']),
      healthRating: 0,
      nutriScore: dishDoc['nutriscore'],
    );
  }


  
}