// MenuItem class represents a dish as it is in a restaurant menu 
// dishId can be used to get nutritional information from firebase

class MenuItem {
  String name;
  String price;
  String dishId;

  
  MenuItem.empty()
      : name = 'empty menu item',
      price = "0,0",
      dishId = 'no id';


  MenuItem({
    required this.name,
    required this.price,
    required this.dishId,
  });

        
}