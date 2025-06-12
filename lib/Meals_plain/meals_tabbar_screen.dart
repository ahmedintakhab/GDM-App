import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'food_list_screen.dart';
import 'recent_tab_screen.dart';
import 'my_food_tab_screen.dart';
import 'meals_data_provider.dart';
import 'package:gdm_app/utils/utils.dart';

class MealsTabBarScreen extends StatefulWidget {
  final String mealType;
  final int recommendedCalories;
  final Function(Map<String, dynamic>) onAddItem;

  const MealsTabBarScreen({
    Key? key,
    required this.mealType,
    required this.recommendedCalories,
    required this.onAddItem,
  }) : super(key: key);

  @override
  _MealsTabBarScreenState createState() => _MealsTabBarScreenState();
}

class _MealsTabBarScreenState extends State<MealsTabBarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, dynamic>> _foodItems = [
    // Traditional Emirati Dishes
    {'foodName': 'Chicken Machbous', 'quantity': '1 cup (200 g)', 'calories': 350},
    {'foodName': 'Lamb Harees', 'quantity': '1 cup (200 g)', 'calories': 400},
    {'foodName': 'Balaleet', 'quantity': '1 cup (150 g)', 'calories': 300},
    {'foodName': 'Khabeesa', 'quantity': '1 cup (150 g)', 'calories': 320},
    {'foodName': 'Thareed', 'quantity': '1 cup (200 g)', 'calories': 380},
    {'foodName': 'Ragag Bread', 'quantity': '1 piece (50 g)', 'calories': 150},
    {'foodName': 'Legemat', 'quantity': '3 pieces (60 g)', 'calories': 200},
    {'foodName': 'Khouzi (Stuffed Lamb)', 'quantity': '1 serving (150 g)', 'calories': 450},
    {'foodName': 'Samak Mashwi (Grilled Fish)', 'quantity': '1 fillet (100 g)', 'calories': 180},
    {'foodName': 'Chami Cheese', 'quantity': '1 oz (28 g)', 'calories': 100},
    {'foodName': 'Margoog', 'quantity': '1 cup (200 g)', 'calories': 360},
    {'foodName': 'Aseeda', 'quantity': '1 cup (150 g)', 'calories': 280},
    {'foodName': 'Biryani (Fish)', 'quantity': '1 cup (200 g)', 'calories': 320},
    {'foodName': 'Salona (Vegetable Stew)', 'quantity': '1 cup (200 g)', 'calories': 200},
    {'foodName': 'Jeshid (Shark Dish)', 'quantity': '1 serving (100 g)', 'calories': 220},

    // Breakfast Items
    {'foodName': 'Foul Medames', 'quantity': '1 cup (200 g)', 'calories': 250},
    {'foodName': 'Shakshuka', 'quantity': '1 cup (200 g)', 'calories': 200},
    {'foodName': 'Khameer Bread', 'quantity': '1 piece (50 g)', 'calories': 140},
    {'foodName': 'Egg Paratha', 'quantity': '1 piece (100 g)', 'calories': 300},
    {'foodName': 'Cheese Manakish', 'quantity': '1 piece (100 g)', 'calories': 280},
    {'foodName': 'Zaatar Manakish', 'quantity': '1 piece (100 g)', 'calories': 250},
    {'foodName': 'Labneh Sandwich', 'quantity': '1 sandwich (150 g)', 'calories': 300},
    {'foodName': 'Oatmeal with Dates', 'quantity': '1 cup (200 g)', 'calories': 220},
    {'foodName': 'Boiled Egg Sandwich', 'quantity': '1 sandwich (150 g)', 'calories': 280},
    {'foodName': 'Croissant (Plain)', 'quantity': '1 piece (50 g)', 'calories': 200},
    {'foodName': 'Cheese Croissant', 'quantity': '1 piece (60 g)', 'calories': 250},
    {'foodName': 'French Toast', 'quantity': '1 slice (70 g)', 'calories': 150},
    {'foodName': 'Pancakes (Plain)', 'quantity': '2 pieces (100 g)', 'calories': 200},
    {'foodName': 'Avocado Toast', 'quantity': '1 slice (100 g)', 'calories': 240},
    {'foodName': 'Fruit Salad', 'quantity': '1 cup (150 g)', 'calories': 100},

    // Lunch and Dinner Proteins
    {'foodName': 'Grilled Chicken Breast', 'quantity': '3 oz (85 g)', 'calories': 140},
    {'foodName': 'Lamb Kebab', 'quantity': '1 skewer (100 g)', 'calories': 250},
    {'foodName': 'Beef Shawarma', 'quantity': '1 wrap (150 g)', 'calories': 400},
    {'foodName': 'Chicken Shawarma', 'quantity': '1 wrap (150 g)', 'calories': 350},
    {'foodName': 'Tofu', 'quantity': '3 oz (85 g)', 'calories': 70},
    {'foodName': 'Falafel', 'quantity': '1 ball (25 g)', 'calories': 60},
    {'foodName': 'Grilled Salmon', 'quantity': '3 oz (85 g)', 'calories': 175},
    {'foodName': 'Egg (Boiled)', 'quantity': '1 large (50 g)', 'calories': 78},
    {'foodName': 'Lentil Dal', 'quantity': '1 cup (200 g)', 'calories': 230},
    {'foodName': 'Chickpeas (Cooked)', 'quantity': '1 cup (164 g)', 'calories': 269},
    {'foodName': 'Beef Kofta', 'quantity': '1 skewer (100 g)', 'calories': 260},
    {'foodName': 'Chicken Tikka', 'quantity': '1 skewer (100 g)', 'calories': 200},
    {'foodName': 'Prawn Curry', 'quantity': '1 cup (200 g)', 'calories': 300},
    {'foodName': 'Grilled Hammour', 'quantity': '1 fillet (100 g)', 'calories': 190},
    {'foodName': 'Mutton Rogan Josh', 'quantity': '1 cup (200 g)', 'calories': 350},
    {'foodName': 'Paneer Tikka', 'quantity': '1 skewer (100 g)', 'calories': 250},
    {'foodName': 'Chicken Kabsa', 'quantity': '1 cup (200 g)', 'calories': 340},
    {'foodName': 'Beef Mandi', 'quantity': '1 cup (200 g)', 'calories': 400},
    {'foodName': 'Grilled Quail', 'quantity': '1 piece (100 g)', 'calories': 200},
    {'foodName': 'Tuna Steak', 'quantity': '3 oz (85 g)', 'calories': 150},

    // Grains and Breads
    {'foodName': 'Basmati Rice (Cooked)', 'quantity': '1 cup (158 g)', 'calories': 205},
    {'foodName': 'Paratha', 'quantity': '1 piece (80 g)', 'calories': 260},
    {'foodName': 'Naan Bread', 'quantity': '1 piece (100 g)', 'calories': 300},
    {'foodName': 'Pita Bread', 'quantity': '1 piece (60 g)', 'calories': 165},
    {'foodName': 'Bulgur (Cooked)', 'quantity': '1 cup (182 g)', 'calories': 151},
    {'foodName': 'Quinoa (Cooked)', 'quantity': '1 cup (185 g)', 'calories': 222},
    {'foodName': 'Vermicelli (Cooked)', 'quantity': '1 cup (140 g)', 'calories': 200},
    {'foodName': 'Rice Flakes (Poha)', 'quantity': '1 cup (150 g)', 'calories': 180},
    {'foodName': 'Semolina (Sooji)', 'quantity': '1 cup (167 g)', 'calories': 600},
    {'foodName': 'Whole Wheat Roti', 'quantity': '1 piece (40 g)', 'calories': 120},
    {'foodName': 'Tandoori Naan', 'quantity': '1 piece (100 g)', 'calories': 280},
    {'foodName': 'Garlic Naan', 'quantity': '1 piece (100 g)', 'calories': 320},
    {'foodName': 'Chapati', 'quantity': '1 piece (50 g)', 'calories': 150},
    {'foodName': 'Brown Rice (Cooked)', 'quantity': '1 cup (195 g)', 'calories': 216},
    {'foodName': 'Couscous (Cooked)', 'quantity': '1 cup (157 g)', 'calories': 176},

    // Fruits
    {'foodName': 'Dates (Deglet Noor)', 'quantity': '1 piece (7.1 g)', 'calories': 20},
    {'foodName': 'Banana', 'quantity': '1 medium (118 g)', 'calories': 105},
    {'foodName': 'Mango', 'quantity': '1 cup (165 g)', 'calories': 99},
    {'foodName': 'Pomegranate', 'quantity': '1 cup (174 g)', 'calories': 144},
    {'foodName': 'Orange', 'quantity': '1 medium (131 g)', 'calories': 62},
    {'foodName': 'Apple', 'quantity': '1 medium (182 g)', 'calories': 95},
    {'foodName': 'Avocado', 'quantity': '1/2 fruit (68 g)', 'calories': 160},
    {'foodName': 'Dried Apricots', 'quantity': '1 oz (28 g)', 'calories': 68},
    {'foodName': 'Raisins', 'quantity': '1 oz (28 g)', 'calories': 85},
    {'foodName': 'Watermelon', 'quantity': '1 cup (152 g)', 'calories': 46},
    {'foodName': 'Pineapple', 'quantity': '1 cup (165 g)', 'calories': 82},
    {'foodName': 'Grapes', 'quantity': '1 cup (151 g)', 'calories': 104},
    {'foodName': 'Strawberry', 'quantity': '1 cup (144 g)', 'calories': 46},
    {'foodName': 'Kiwi', 'quantity': '1 medium (69 g)', 'calories': 42},
    {'foodName': 'Papaya', 'quantity': '1 cup (145 g)', 'calories': 62},

    // Vegetables
    {'foodName': 'Eggplant (Cooked)', 'quantity': '1 cup (99 g)', 'calories': 35},
    {'foodName': 'Okra (Cooked)', 'quantity': '1 cup (160 g)', 'calories': 35},
    {'foodName': 'Spinach (Cooked)', 'quantity': '1 cup (180 g)', 'calories': 41},
    {'foodName': 'Broccoli (Cooked)', 'quantity': '1 cup (156 g)', 'calories': 55},
    {'foodName': 'Carrot (Raw)', 'quantity': '1 medium (61 g)', 'calories': 25},
    {'foodName': 'Cucumber', 'quantity': '1 cup (104 g)', 'calories': 16},
    {'foodName': 'Tomato', 'quantity': '1 medium (123 g)', 'calories': 22},
    {'foodName': 'Zucchini (Cooked)', 'quantity': '1 cup (180 g)', 'calories': 33},
    {'foodName': 'Potato (Boiled)', 'quantity': '1 medium (167 g)', 'calories': 144},
    {'foodName': 'Sweet Potato (Baked)', 'quantity': '1 medium (130 g)', 'calories': 112},
    {'foodName': 'Green Beans (Cooked)', 'quantity': '1 cup (125 g)', 'calories': 44},
    {'foodName': 'Cauliflower (Cooked)', 'quantity': '1 cup (124 g)', 'calories': 29},
    {'foodName': 'Bell Pepper (Raw)', 'quantity': '1 medium (119 g)', 'calories': 25},
    {'foodName': 'Mushrooms (Cooked)', 'quantity': '1 cup (156 g)', 'calories': 44},
    {'foodName': 'Kale (Cooked)', 'quantity': '1 cup (130 g)', 'calories': 36},

    // Dairy and Alternatives
    {'foodName': 'Whole Milk', 'quantity': '1 cup (240 ml)', 'calories': 149},
    {'foodName': 'Labneh', 'quantity': '2 tbsp (30 g)', 'calories': 60},
    {'foodName': 'Yogurt (Plain, Full-Fat)', 'quantity': '1 cup (245 g)', 'calories': 138},
    {'foodName': 'Feta Cheese', 'quantity': '1 oz (28 g)', 'calories': 75},
    {'foodName': 'Cheddar Cheese', 'quantity': '1 oz (28 g)', 'calories': 115},
    {'foodName': 'Butter', 'quantity': '1 tbsp (14 g)', 'calories': 102},
    {'foodName': 'Ghee', 'quantity': '1 tbsp (14 g)', 'calories': 112},
    {'foodName': 'Cream Cheese', 'quantity': '1 oz (28 g)', 'calories': 100},
    {'foodName': 'Camel Milk', 'quantity': '1 cup (240 ml)', 'calories': 120},
    {'foodName': 'Greek Yogurt (Full-Fat)', 'quantity': '1 cup (245 g)', 'calories': 220},
    {'foodName': 'Mozzarella Cheese', 'quantity': '1 oz (28 g)', 'calories': 85},
    {'foodName': 'Parmesan Cheese', 'quantity': '1 oz (28 g)', 'calories': 110},
    {'foodName': 'Sour Cream', 'quantity': '2 tbsp (30 g)', 'calories': 60},
    {'foodName': 'Almond Milk', 'quantity': '1 cup (240 ml)', 'calories': 40},
    {'foodName': 'Coconut Milk', 'quantity': '1 cup (240 ml)', 'calories': 140},

    // Nuts and Seeds
    {'foodName': 'Almonds', 'quantity': '1 oz (28 g)', 'calories': 164},
    {'foodName': 'Pistachios', 'quantity': '1 oz (28 g)', 'calories': 159},
    {'foodName': 'Cashews', 'quantity': '1 oz (28 g)', 'calories': 157},
    {'foodName': 'Walnuts', 'quantity': '1 oz (28 g)', 'calories': 185},
    {'foodName': 'Peanuts', 'quantity': '1 oz (28 g)', 'calories': 161},
    {'foodName': 'Sunflower Seeds', 'quantity': '1 oz (28 g)', 'calories': 163},
    {'foodName': 'Pumpkin Seeds', 'quantity': '1 oz (28 g)', 'calories': 151},
    {'foodName': 'Chia Seeds', 'quantity': '1 oz (28 g)', 'calories': 137},
    {'foodName': 'Sesame Seeds', 'quantity': '1 oz (28 g)', 'calories': 161},
    {'foodName': 'Makhana (Fox Nuts)', 'quantity': '1 oz (28 g)', 'calories': 100},
    {'foodName': 'Pine Nuts', 'quantity': '1 oz (28 g)', 'calories': 191},
    {'foodName': 'Hazelnuts', 'quantity': '1 oz (28 g)', 'calories': 176},
    {'foodName': 'Flaxseeds', 'quantity': '1 oz (28 g)', 'calories': 150},
    {'foodName': 'Poppy Seeds', 'quantity': '1 oz (28 g)', 'calories': 147},
    {'foodName': 'Hemp Seeds', 'quantity': '1 oz (28 g)', 'calories': 166},

    // Snacks
    {'foodName': 'Baklava', 'quantity': '1 piece (50 g)', 'calories': 200},
    {'foodName': 'Kunafa', 'quantity': '1 piece (50 g)', 'calories': 180},
    {'foodName': 'Halwa', 'quantity': '1 piece (50 g)', 'calories': 150},
    {'foodName': 'Samosa (Vegetable)', 'quantity': '1 piece (100 g)', 'calories': 250},
    {'foodName': 'Samosa (Meat)', 'quantity': '1 piece (100 g)', 'calories': 300},
    {'foodName': 'Pakora', 'quantity': '1 piece (30 g)', 'calories': 100},
    {'foodName': 'Jalebi', 'quantity': '1 piece (50 g)', 'calories': 150},
    {'foodName': 'Maamoul', 'quantity': '1 piece (30 g)', 'calories': 120},
    {'foodName': 'Potato Chips', 'quantity': '1 oz (28 g)', 'calories': 150},
    {'foodName': 'Chocolate Brownie', 'quantity': '1 piece (50 g)', 'calories': 200},
    {'foodName': 'Popcorn (Plain)', 'quantity': '1 cup (11 g)', 'calories': 40},
    {'foodName': 'Dried Mango Slices', 'quantity': '1 oz (28 g)', 'calories': 90},
    {'foodName': 'Roasted Chickpeas', 'quantity': '1 oz (28 g)', 'calories': 120},
    {'foodName': 'Pretzels', 'quantity': '1 oz (28 g)', 'calories': 110},
    {'foodName': 'Rice Crackers', 'quantity': '1 oz (28 g)', 'calories': 100},
    {'foodName': 'Fruit Roll-Up', 'quantity': '1 piece (21 g)', 'calories': 80},
    {'foodName': 'Energy Bar', 'quantity': '1 bar (50 g)', 'calories': 200},
    {'foodName': 'Granola Bar', 'quantity': '1 bar (40 g)', 'calories': 180},
    {'foodName': 'Date Bar', 'quantity': '1 bar (40 g)', 'calories': 160},
    {'foodName': 'Cheese Puffs', 'quantity': '1 oz (28 g)', 'calories': 150},

    // Fast Foods: Pizzas
    {'foodName': 'Pizza (Margherita)', 'quantity': '1 slice (100 g)', 'calories': 250},
    {'foodName': 'Pizza (Pepperoni)', 'quantity': '1 slice (100 g)', 'calories': 280},
    {'foodName': 'Pizza (Chicken BBQ)', 'quantity': '1 slice (100 g)', 'calories': 270},
    {'foodName': 'Pizza (Veggie)', 'quantity': '1 slice (100 g)', 'calories': 220},
    {'foodName': 'Pizza (Meat Lovers)', 'quantity': '1 slice (100 g)', 'calories': 300},
    {'foodName': 'Pizza (Hawaiian)', 'quantity': '1 slice (100 g)', 'calories': 260},
    {'foodName': 'Pizza (Four Cheese)', 'quantity': '1 slice (100 g)', 'calories': 290},
    {'foodName': 'Pizza (Tandoori Chicken)', 'quantity': '1 slice (100 g)', 'calories': 270},
    {'foodName': 'Pizza (Pesto)', 'quantity': '1 slice (100 g)', 'calories': 250},
    {'foodName': 'Pizza (Spicy Sausage)', 'quantity': '1 slice (100 g)', 'calories': 280},
    {'foodName': 'Stuffed Crust Pizza (Cheese)', 'quantity': '1 slice (120 g)', 'calories': 320},
    {'foodName': 'Thin Crust Pizza (Margherita)', 'quantity': '1 slice (80 g)', 'calories': 200},
    {'foodName': 'Deep Dish Pizza (Pepperoni)', 'quantity': '1 slice (150 g)', 'calories': 400},
    {'foodName': 'Pizza (Mushroom)', 'quantity': '1 slice (100 g)', 'calories': 230},
    {'foodName': 'Pizza (Seafood)', 'quantity': '1 slice (100 g)', 'calories': 260},

    // Fast Foods: Burgers
    {'foodName': 'Cheeseburger', 'quantity': '1 burger (150 g)', 'calories': 400},
    {'foodName': 'Double Cheeseburger', 'quantity': '1 burger (200 g)', 'calories': 550},
    {'foodName': 'Chicken Burger', 'quantity': '1 burger (150 g)', 'calories': 350},
    {'foodName': 'Veggie Burger', 'quantity': '1 burger (150 g)', 'calories': 300},
    {'foodName': 'Fish Burger', 'quantity': '1 burger (150 g)', 'calories': 320},
    {'foodName': 'Spicy Chicken Burger', 'quantity': '1 burger (150 g)', 'calories': 380},
    {'foodName': 'Mushroom Swiss Burger', 'quantity': '1 burger (150 g)', 'calories': 420},
    {'foodName': 'Bacon Cheeseburger', 'quantity': '1 burger (160 g)', 'calories': 450},
    {'foodName': 'Tandoori Chicken Burger', 'quantity': '1 burger (150 g)', 'calories': 360},
    {'foodName': 'Falafel Burger', 'quantity': '1 burger (150 g)', 'calories': 330},
    {'foodName': 'Double Patty Beef Burger', 'quantity': '1 burger (200 g)', 'calories': 600},
    {'foodName': 'Lamb Burger', 'quantity': '1 burger (150 g)', 'calories': 400},
    {'foodName': 'BBQ Beef Burger', 'quantity': '1 burger (150 g)', 'calories': 420},
    {'foodName': 'Avocado Chicken Burger', 'quantity': '1 burger (160 g)', 'calories': 400},
    {'foodName': 'Egg Cheeseburger', 'quantity': '1 burger (160 g)', 'calories': 430},

    // Other Fast Foods
    {'foodName': 'French Fries', 'quantity': '1 small serving (100 g)', 'calories': 312},
    {'foodName': 'Chicken Nuggets', 'quantity': '4 pieces (64 g)', 'calories': 200},
    {'foodName': 'Sushi (California Roll)', 'quantity': '1 piece (30 g)', 'calories': 40},
    {'foodName': 'Butter Chicken', 'quantity': '1 cup (240 g)', 'calories': 500},
    {'foodName': 'Biryani (Chicken)', 'quantity': '1 cup (200 g)', 'calories': 300},
    {'foodName': 'Hummus', 'quantity': '2 tbsp (30 g)', 'calories': 50},
    {'foodName': 'Chicken Wings (Buffalo)', 'quantity': '4 pieces (100 g)', 'calories': 300},
    {'foodName': 'Onion Rings', 'quantity': '1 small serving (100 g)', 'calories': 350},
    {'foodName': 'Chicken Tenders', 'quantity': '3 pieces (100 g)', 'calories': 250},
    {'foodName': 'Taco (Beef)', 'quantity': '1 taco (100 g)', 'calories': 200},
    {'foodName': 'Burrito (Chicken)', 'quantity': '1 burrito (200 g)', 'calories': 400},
    {'foodName': 'Quesadilla (Cheese)', 'quantity': '1 piece (100 g)', 'calories': 300},
    {'foodName': 'Hot Dog', 'quantity': '1 hot dog (100 g)', 'calories': 250},
    {'foodName': 'Fried Chicken Drumstick', 'quantity': '1 piece (100 g)', 'calories': 300},
    {'foodName': 'Sub Sandwich (Turkey)', 'quantity': '1 sandwich (150 g)', 'calories': 350},

    // Beverages
    {'foodName': 'Arabic Coffee (Gahwa)', 'quantity': '1 cup (100 ml)', 'calories': 5},
    {'foodName': 'Karak Chai', 'quantity': '1 cup (240 ml)', 'calories': 150},
    {'foodName': 'Orange Juice', 'quantity': '1 cup (240 ml)', 'calories': 112},
    {'foodName': 'Mango Lassi', 'quantity': '1 cup (240 ml)', 'calories': 200},
    {'foodName': 'Coca-Cola', 'quantity': '1 can (330 ml)', 'calories': 140},
    {'foodName': 'Pomegranate Juice', 'quantity': '1 cup (240 ml)', 'calories': 134},
    {'foodName': 'Whole Milk Latte', 'quantity': '1 cup (240 ml)', 'calories': 180},
    {'foodName': 'Date Milkshake', 'quantity': '1 cup (240 ml)', 'calories': 250},
    {'foodName': 'Avocado Smoothie', 'quantity': '1 cup (240 ml)', 'calories': 220},
    {'foodName': 'Sparkling Water', 'quantity': '1 cup (240 ml)', 'calories': 0},
    {'foodName': 'Iced Americano', 'quantity': '1 cup (240 ml)', 'calories': 10},
    {'foodName': 'Lemon Mint Juice', 'quantity': '1 cup (240 ml)', 'calories': 80},
    {'foodName': 'Watermelon Juice', 'quantity': '1 cup (240 ml)', 'calories': 70},
    {'foodName': 'Falooda', 'quantity': '1 cup (240 ml)', 'calories': 250},
    {'foodName': 'Green Tea', 'quantity': '1 cup (240 ml)', 'calories': 0},
  ];

  List<Map<String, dynamic>> _filteredFoodItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isNotEmpty) {
        _isSearching = true;
        _filteredFoodItems = _foodItems
            .where((food) => food['foodName'].toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        _isSearching = false;
        _filteredFoodItems.clear();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _filteredFoodItems.clear();
    });
  }

  void _addToRecent(Map<String, dynamic> food) {
    widget.onAddItem(food); // Calls MealsProvider.addMealItem, which shows toast
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealsProvider>(
      builder: (context, mealsProvider, child) {
        final recentItems = mealsProvider.mealItems[widget.mealType] ?? [];
        final currentCalories = recentItems.fold<int>(
          0,
              (sum, item) => sum + (item['calories'] as num).toInt(),
        );
        final recentCount = recentItems.length;

        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF5AA189),
            statusBarIconBrightness: Brightness.light,
          ),
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              Container(
                color: const Color(0xFF5AA189),
                child: SafeArea(
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.mealType,
                          style: TextStyle(color: Colors.white, fontSize: 24.sp),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '$currentCalories/${widget.recommendedCalories} Cal',
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                      ],
                    ),
                    actions: [
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.apple, color: Colors.white),
                            onPressed: () {
                              print('Apple icon tapped');
                            },
                          ),
                          if (recentCount > 0)
                            Positioned(
                              right: 8.w,
                              top: 8.h,
                              child: CircleAvatar(
                                radius: 8.r,
                                backgroundColor: Colors.red,
                                child: Text(
                                  recentCount.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                    flexibleSpace: Container(color: const Color(0xFF5AA189)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a food',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _isSearching
                        ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: _clearSearch,
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _isSearching
                    ? FoodListScreen(
                  foodItems: _filteredFoodItems,
                  onAdd: _addToRecent,
                  mealType: widget.mealType,
                )
                    : Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        indicator: BoxDecoration(
                          color: const Color(0xFF5AA189),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                        tabs: const [
                          Tab(text: 'Recent'),
                          Tab(text: 'My food'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          RecentTabScreen(mealType: widget.mealType),
                          MyFoodTabScreen(
                            mealType: widget.mealType,
                            onAddItem: widget.onAddItem,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}