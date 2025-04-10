import 'package:flutter/material.dart';
import 'dart:math';

// Model class for meal data
class Meal {
  final String name;
  final String imageUrl;
  final String mealType; // breakfast, lunch, dinner
  final int duration;
  final int calories;
  final double rating;

  Meal({
    required this.name,
    required this.imageUrl,
    required this.mealType,
    required this.duration,
    required this.calories,
    required this.rating,
  });
}

// Shared list of logged meals that can be accessed from MyMealsTab
class LoggedMealsData {
  static List<Meal> loggedMeals = [];

  static void addMeal(Meal meal) {
    loggedMeals.add(meal);
  }
}

class MealPlanTab extends StatefulWidget {
  @override
  _MealPlanTabState createState() => _MealPlanTabState();
}

class _MealPlanTabState extends State<MealPlanTab> {
  // Sample meal data organized by type
  final List<Meal> breakfastMeals = [
    Meal(
      name: 'Toast with Cream Cheese and Egg',
      imageUrl: 'https://www.eatingwell.com/thmb/088YHsNmHkUQ7iNGP4375MiAXOY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/article_7866255_foods-you-should-eat-every-week-to-lose-weight_-04-d58e9c481bce4a29b47295baade4072d.jpg',
      mealType: 'Breakfast',
      duration: 10,
      calories: 366,
      rating: 4.6,
    ),
    Meal(
      name: 'Oatmeal with Berries',
      imageUrl: 'https://images.unsplash.com/photo-1517673132405-a56a62b18caf',
      mealType: 'Breakfast',
      duration: 15,
      calories: 290,
      rating: 4.8,
    ),
    Meal(
      name: 'Green Smoothie Bowl',
      imageUrl: 'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2',
      mealType: 'Breakfast',
      duration: 8,
      calories: 220,
      rating: 4.3,
    ),
  ];

  final List<Meal> lunchMeals = [
    Meal(
      name: 'Chicken Salad with Avocado',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
      mealType: 'Lunch',
      duration: 20,
      calories: 450,
      rating: 4.7,
    ),
    Meal(
      name: 'Mediterranean Wrap',
      imageUrl: 'https://images.unsplash.com/photo-1529059997568-3d847b1154f0',
      mealType: 'Lunch',
      duration: 15,
      calories: 410,
      rating: 4.5,
    ),
    Meal(
      name: 'Quinoa Bowl with Roasted Vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
      mealType: 'Lunch',
      duration: 25,
      calories: 380,
      rating: 4.4,
    ),
  ];

  final List<Meal> dinnerMeals = [
    Meal(
      name: 'Grilled Salmon with Asparagus',
      imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2',
      mealType: 'Dinner',
      duration: 30,
      calories: 520,
      rating: 4.9,
    ),
    Meal(
      name: 'Vegetable Stir Fry with Tofu',
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19',
      mealType: 'Dinner',
      duration: 25,
      calories: 380,
      rating: 4.3,
    ),
    Meal(
      name: 'Spaghetti with Tomato Sauce',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141',
      mealType: 'Dinner',
      duration: 20,
      calories: 490,
      rating: 4.6,
    ),
  ];

  late List<Meal> currentMeals;
  late String currentMealType;
  int selectedMealIndex = 0;

  @override
  void initState() {
    super.initState();
    _setCurrentMealByTime();
  }

  void _setCurrentMealByTime() {
    final now = TimeOfDay.now();
    final currentHour = now.hour;

    // 5 AM to 11:59 AM - Breakfast
    if (currentHour >= 5 && currentHour < 12) {
      currentMeals = breakfastMeals;
      currentMealType = 'Breakfast';
    }
    // 12 PM to 4:59 PM - Lunch
    else if (currentHour >= 12 && currentHour < 17) {
      currentMeals = lunchMeals;
      currentMealType = 'Lunch';
    }
    // 5 PM to 4:59 AM - Dinner
    else {
      currentMeals = dinnerMeals;
      currentMealType = 'Dinner';
    }

    // Use a random index to show different meals
    selectedMealIndex = Random().nextInt(currentMeals.length);
  }

  void _logMeal(Meal meal) {
    LoggedMealsData.addMeal(meal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${meal.name} added to My Meals'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showNextMeal() {
    setState(() {
      selectedMealIndex = (selectedMealIndex + 1) % currentMeals.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentMeal = currentMeals[selectedMealIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Your daily $currentMealType recipe',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _showNextMeal,
                  tooltip: 'Show another meal',
                ),
              ],
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      currentMeal.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(label: Text(currentMeal.mealType)),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text(currentMeal.rating.toString()),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          currentMeal.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text('${currentMeal.duration} min - ${currentMeal.calories} kcal'),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _logMeal(currentMeal),
                                child: Text(
                                  'Log',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite_border),
                              color: Colors.red,
                              onPressed: () {},
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            // Browse meals from other meal types
            Text(
              'Browse Other Meal Types',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMealTypeButton('Breakfast', breakfastMeals),
                _buildMealTypeButton('Lunch', lunchMeals),
                _buildMealTypeButton('Dinner', dinnerMeals),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text('NEW RECIPE IN', style: TextStyle(color: Colors.grey)),
                  Text('4:41:12', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                  SizedBox(height: 10),
                  Container(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0XFF5AA189)),
                      child: Text('Try Plus+ free', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeButton(String mealType, List<Meal> meals) {
    bool isCurrentType = mealType == currentMealType;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentMeals = meals;
          currentMealType = mealType;
          selectedMealIndex = 0;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isCurrentType ? Color(0XFF5AA189) : Colors.grey.shade200,
      ),
      child: Text(
        mealType,
        style: TextStyle(
          color: isCurrentType ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}