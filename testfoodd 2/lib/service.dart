import 'dart:convert';
import 'package:flutter/services.dart';

class FoodItem {
  final String name;
  final String category;

  FoodItem({required this.name, required this.category});
}

Future<List<FoodItem>> fetchFoodItemsFromJson() async {
  String jsonString = await rootBundle.loadString('assets/food_items.json');
  final jsonData = json.decode(jsonString);

  List<FoodItem> foodItems = [];
  for (var item in jsonData) {
    FoodItem foodItem = FoodItem(
      name: item['name'],
      category: item['category'],
    );
    foodItems.add(foodItem);
  }

  return foodItems;
}