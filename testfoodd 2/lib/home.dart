import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String selectedCategory = 'Appetizer';

  void updateSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Menu'),
      ),
      body: Column(
        children: [
          MenuCategory(
            selectedCategory: selectedCategory,
            onTap: updateSelectedCategory,
          ),
          Expanded(
            child: FoodItemList(category: selectedCategory),
          ),
        ],
      ),
    );
  }
}

class MenuCategory extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onTap;

  const MenuCategory({
    required this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CategoryItem(
            title: 'Appetizer',
            image: 'assets/appetizer.jpg',
            selected: selectedCategory == 'Appetizer',
            onTap: onTap,
            itemSize: 120,
          ),
          CategoryItem(
            title: 'Main Course',
            image: 'assets/main_course.jpg',
            selected: selectedCategory == 'Main Course',
            onTap: onTap,
            itemSize: 120,
          ),
          CategoryItem(
            title: 'Dessert',
            image: 'assets/dessert.jpg',
            selected: selectedCategory == 'Dessert',
            onTap: onTap,
            itemSize: 120,
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final bool selected;
  final Function(String) onTap;
  final double itemSize; // เพิ่มพรอพเพอร์ตี้นี้

  const CategoryItem({
    required this.title,
    required this.image,
    required this.selected,
    required this.onTap,
    required this.itemSize, // เพิ่มพรอพเพอร์ตี้นี้
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(title),
      child: Container(
        width: itemSize, // กำหนดความกว้างเท่ากับ itemSize
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? Colors.blue : Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}

Future<List<FoodItem>> fetchFoodItemsFromJson() async {
  final jsonString = await rootBundle.loadString('assets/food_items.json');
  final jsonData = json.decode(jsonString);

  final foodItems = <FoodItem>[];
  for (final item in jsonData) {
    final foodItem = FoodItem(
      name: item['name'],
      category: item['category'],
    );
    foodItems.add(foodItem);
  }

  return foodItems;
}

class FoodItemList extends StatefulWidget {
  final String category;

  const FoodItemList({required this.category});

  @override
  _FoodItemListState createState() => _FoodItemListState();
}

class _FoodItemListState extends State<FoodItemList> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category;
  }

  @override
  void didUpdateWidget(FoodItemList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category != oldWidget.category) {
      setState(() {
        selectedCategory = widget.category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FoodItem>>(
      future: fetchFoodItemsFromJson(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final foodItems = snapshot.data!;
          final filteredItems = foodItems
              .where((item) => item.category == selectedCategory)
              .toList();

          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredItems[index].name),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading food items');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class FoodItem {
  final String name;
  final String category;

  const FoodItem({required this.name, required this.category});
}
