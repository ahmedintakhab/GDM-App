import 'package:flutter/material.dart';
import 'meals_plan_tab.dart';
import 'my_meal_tab.dart';



class MealsScreen extends StatefulWidget {
  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Meal plan'),
            Tab(text: 'My meals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MealPlanTab(),
          MyMealsTab(),
        ],
      ),
    );
  }
}
