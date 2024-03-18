import 'package:flutter/material.dart';

class RestaurantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Details'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant Name: ABC Restaurant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Location: XYZ Street, City',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Meal Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Chicken Salad'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Calories: 300'),
                  Text('Fat: 10g'),
                  Text('Protein: 20g'),
                  Text('Carbs: 15g'),
                ],
              ),
            ),
            ListTile(
              title: Text('Vegetable Soup'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Calories: 150'),
                  Text('Fat: 5g'),
                  Text('Protein: 8g'),
                  Text('Carbs: 20g'),
                ],
              ),
            ),
            // Add more ListTile widgets for other meals
          ],
        ),
      ),
    );
  }
}