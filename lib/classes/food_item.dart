
class FoodItem{


  // TODO: possibly implement a way to tie each foodtype to a logo style picture to have ability to display visuals

  String name;
  // totalCalories is the total calorie count of order 
  double totalCalories;
  int weight;
  // calories, protein, fat, carbohydrates, saturatedFat are values per 100g
  double calories;
  double protein;
  double fat;
  double saturatedFat;
  double carbohydrates;
  double sugar;
  double fiber;
  String foodType;
  double price;

 // healthRating to be calculated from data of FoodItem and UserInformation
  int healthRating;

  String restaurant;
  // restaurant that offers the FoodItem as content of FoodItems may vary in different restaurants.

  bool fullView = false;


  FoodItem({
    required this.name,
    required this.totalCalories,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.saturatedFat,
    required this.carbohydrates,
    required this.restaurant,
    required this.foodType,
    required this.sugar,
    required this.fiber,
    this.healthRating = 0,
    this.weight = 100,
    required this.price,


  });

  static set view(bool fullView){
    fullView = fullView;
  }

    static FoodItem getEmptyFoodItem(){
    FoodItem testItem = FoodItem(name: 'Empty FoodItem. If this is displayed it is likely due to a bug in code',
      totalCalories: 0,
      calories: 0,
      protein: 0,
      fat: 0,
      saturatedFat: 0,
      carbohydrates: 0,
      sugar: 0,
      restaurant: '',
      foodType: '',
      healthRating: 0,
      weight: 0,
      price: 0,
      fiber: 0,
      );
      return testItem;
  }

  static FoodItem getTestItem(){
    FoodItem testItem = FoodItem(name: 'Happy Meal',
      totalCalories: 542,
      calories: 230.7,
      protein: 11.5,
      fat: 12.3,
      saturatedFat: 4.3,
      carbohydrates: 17.9,
      sugar: 3.7,
      restaurant: 'McDonalds',
      foodType: 'hamburger',
      healthRating: 3,
      weight: (100*542/230.7).ceil(),
      price: 6.95,
      fiber: 2.3,
      );
      return testItem;
  }

  static List<FoodItem> getTestMenu(){
    List<FoodItem> testMenu = [];

    testMenu.add(
      FoodItem(name: 'Big Mac',
      totalCalories: 542,
      calories: 230.7,
      protein: 11.5,
      fat: 12.3,
      saturatedFat: 4.3,
      carbohydrates: 17.9,
      sugar: 3.7,
      restaurant: 'McDonalds',
      foodType: 'hamburger',
      healthRating: 3,
      weight: (100*542/230.7).ceil(),
      price: 5.95,
      fiber: 3.7,
      )
    );

    testMenu.add(
      FoodItem(name: 'Fiesta Chicken Salad',
      totalCalories: 420,
      calories: 118.3,
      protein: 6.5,
      fat: 7.6,
      saturatedFat: 1.9,
      carbohydrates: 5.9,
      sugar: 1.7,
      restaurant: 'McDonalds',
      foodType: 'salad',
      healthRating: 1,
      weight: (100*420/118.3).ceil(),
      price: 7.95,
      fiber: 5.3,

      )
    );

    testMenu.add(
      FoodItem(name: 'Classic McWrap Veggie',
      totalCalories: 459,
      calories: 227,
      protein: 11,
      fat: 11,
      saturatedFat: 1.2,
      carbohydrates: 22,
      sugar: 1.6,
      restaurant: 'McDonalds',
      foodType: 'wrap',
      healthRating: 2,
      weight: (100*459/227).ceil(),
      price: 4.95,
      fiber: 8.3,

      )
    );

    testMenu.add(
      FoodItem(name: 'Chocolate Sundae Mix',
      totalCalories: 373,
      calories: 192,
      protein: 3.4,
      fat: 5,
      saturatedFat: 3.7,
      carbohydrates: 34,
      sugar: 32,
      restaurant: 'McDonalds',
      foodType: 'icecream',
      healthRating: 3,
      weight: (100*373/192).ceil(),
      price: 2.95,
      fiber: 0.1,

      )
    );

    testMenu.add(
      FoodItem(name: 'Mini Salad',
      totalCalories: 25,
      calories: (25/1.55).roundToDouble(),
      protein: 1,
      fat: 0.2,
      saturatedFat: 0.1,
      carbohydrates: 2.1,
      sugar: 2,
      restaurant: 'Hesburger',
      foodType: 'salad',
      healthRating: 0,
      weight: 155,
      price: 3.95,
      fiber: 3.5,
      )
    );


    return testMenu;
  }

  
}