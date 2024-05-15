class FoodType{

  int id;
  String name;

  //possibly add picture icon later

  FoodType({
    required this.id,
    required this.name,
  });

  /*
Food types currently not stored on databse. Might be smart to do in the future to allow adding new food types without modifying the code.
 */


  static List<FoodType> getProteinTypes(){

    List<FoodType> proteinTypes = [];
    proteinTypes.add(FoodType(id: 0, name: 'Poultry'));
    proteinTypes.add(FoodType(id: 1, name: 'Beef'));
    proteinTypes.add(FoodType(id: 2, name: 'Pork'));
    proteinTypes.add(FoodType(id: 3, name: 'Seafood'));
    proteinTypes.add(FoodType(id: 4, name: 'Plant Based Protein'));
    proteinTypes.add(FoodType(id: 5, name: 'Game'));

    return proteinTypes;
  }

  static List<FoodType> getSideDishTypes(){

    List<FoodType> sideTypes = [];
    sideTypes.add(FoodType(id: 6, name: 'Potatoes'));
    sideTypes.add(FoodType(id: 7, name: 'Pasta'));
    sideTypes.add(FoodType(id: 8, name: 'Rice'));
    sideTypes.add(FoodType(id: 9, name: 'Vegetables'));
    sideTypes.add(FoodType(id: 10, name: 'Soup'));
    sideTypes.add(FoodType(id: 11, name: 'Bread'));

    return sideTypes;
  }

  static List<FoodType> getAllFoodTypes(){

    List<FoodType> allFoodTypes = [];

    allFoodTypes.add(FoodType(id: 0, name: 'Poultry'));
    allFoodTypes.add(FoodType(id: 1, name: 'Beef'));
    allFoodTypes.add(FoodType(id: 2, name: 'Pork'));
    allFoodTypes.add(FoodType(id: 3, name: 'Seafood'));
    allFoodTypes.add(FoodType(id: 4, name: 'Plant Based Protein'));
    allFoodTypes.add(FoodType(id: 5, name: 'Game'));
    allFoodTypes.add(FoodType(id: 6, name: 'Potatoes'));
    allFoodTypes.add(FoodType(id: 7, name: 'Pasta'));
    allFoodTypes.add(FoodType(id: 8, name: 'Rice'));
    allFoodTypes.add(FoodType(id: 9, name: 'Vegetables'));
    allFoodTypes.add(FoodType(id: 10, name: 'Soup'));
    allFoodTypes.add(FoodType(id: 11, name: 'Bread'));
    allFoodTypes.add(FoodType(id: 12, name: 'Salad'));
    allFoodTypes.add(FoodType(id: 13, name: 'Pizza'));
    allFoodTypes.add(FoodType(id: 14, name: 'Burger'));
    allFoodTypes.add(FoodType(id: 15, name: 'Dessert'));


    return allFoodTypes;

  }

}

