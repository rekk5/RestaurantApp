import 'package:cloud_firestore/cloud_firestore.dart';

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