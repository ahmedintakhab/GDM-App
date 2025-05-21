import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'food_list_screen.dart';
import 'recent_tab_screen.dart';
import 'my_food_tab_screen.dart';

class MealsTabBarScreen extends StatefulWidget {
  final String mealType;
  final int recommendedCalories;
  final Function(Map<String, dynamic>) onAddItem;

  const MealsTabBarScreen({Key? key, required this.mealType, required this.recommendedCalories, required this.onAddItem}) : super(key: key);

  @override
  _MealsTabBarScreenState createState() => _MealsTabBarScreenState();
}

class _MealsTabBarScreenState extends State<MealsTabBarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _recentCount = 0;

  final List<Map<String, dynamic>> _foodItems = [
    {'name': 'Tofu', 'quantity': '3 oz (85 g)', 'calories': 70},
    {'name': 'Almonds', 'quantity': '1 oz (28 g)', 'calories': 164},
    {'name': 'Banana', 'quantity': '1 medium (118 g)', 'calories': 105},
    {'name': 'Pumpkin Seeds', 'quantity': '1 oz (28 g)', 'calories': 151},
    {'name': 'Spinach', 'quantity': '1 cup (180 g)', 'calories': 41},
    {'name': 'Greek Yogurt', 'quantity': '1 cup (245 g)', 'calories': 130},
    {'name': 'Broccoli', 'quantity': '1 cup (156 g)', 'calories': 55},
    {'name': 'Salmon', 'quantity': '3 oz (85 g)', 'calories': 177},
    {'name': 'Sweet Potato', 'quantity': '1 medium (130 g)', 'calories': 112},
    {'name': 'Lentils', 'quantity': '1 cup cooked (198 g)', 'calories': 230},
    {'name': 'Avocado', 'quantity': '1 whole (200 g)', 'calories': 322},
    {'name': 'Cottage Cheese', 'quantity': '1/2 cup (113 g)', 'calories': 110},
    {'name': 'Carrots', 'quantity': '1 cup chopped (128 g)', 'calories': 52},
    {'name': 'Chia Seeds', 'quantity': '1 oz (28 g)', 'calories': 138},
    {'name': 'Oranges', 'quantity': '1 medium (131 g)', 'calories': 62},
    {'name': 'Boiled Egg', 'quantity': '1 large (50 g)', 'calories': 78},
    {'name': 'Brown Rice', 'quantity': '1 cup cooked (195 g)', 'calories': 216},
    {'name': 'Tomatoes', 'quantity': '1 medium (123 g)', 'calories': 22},
    {'name': 'Beets', 'quantity': '1 cup (136 g)', 'calories': 59},
    {'name': 'Chicken Breast', 'quantity': '3 oz (85 g)', 'calories': 140},
    {'name': 'Oatmeal', 'quantity': '1 cup (234 g)', 'calories': 158},
    {'name': 'Kale', 'quantity': '1 cup chopped (67 g)', 'calories': 33},
    {'name': 'Mango', 'quantity': '1 cup sliced (165 g)', 'calories': 99},
    {'name': 'Quinoa', 'quantity': '1 cup cooked (185 g)', 'calories': 222},
    {'name': 'Edamame', 'quantity': '1 cup (155 g)', 'calories': 189},
    {'name': 'Hummus', 'quantity': '2 tbsp (30 g)', 'calories': 70},
    {'name': 'Zucchini', 'quantity': '1 medium (196 g)', 'calories': 33},
    {'name': 'Whole Wheat Bread', 'quantity': '1 slice (28 g)', 'calories': 69},
    {'name': 'Pear', 'quantity': '1 medium (178 g)', 'calories': 101},
    {'name': 'Berries (mixed)', 'quantity': '1 cup (148 g)', 'calories': 84},
    {'name': 'Prunes', 'quantity': '5 pieces (50 g)', 'calories': 115},
    {'name': 'Milk (low-fat)', 'quantity': '1 cup (244 g)', 'calories': 103},
    {'name': 'Walnuts', 'quantity': '1 oz (28 g)', 'calories': 185},
    {'name': 'Barley', 'quantity': '1 cup cooked (157 g)', 'calories': 193},
    {'name': 'Green Beans', 'quantity': '1 cup (125 g)', 'calories': 44},
    {'name': 'Cucumber', 'quantity': '1 cup sliced (104 g)', 'calories': 16},
    {'name': 'Eggplant', 'quantity': '1 cup cooked (99 g)', 'calories': 35},
    {'name': 'Apples', 'quantity': '1 medium (182 g)', 'calories': 95},
    {'name': 'Peanut Butter', 'quantity': '2 tbsp (32 g)', 'calories': 188},
    {'name': 'Sunflower Seeds', 'quantity': '1 oz (28 g)', 'calories': 164},
    {'name': 'Asparagus', 'quantity': '1 cup (134 g)', 'calories': 27},
    {'name': 'Brussels Sprouts', 'quantity': '1 cup (156 g)', 'calories': 56},
    {'name': 'Apricots', 'quantity': '3 pieces (100 g)', 'calories': 48},
    {'name': 'Raspberries', 'quantity': '1 cup (123 g)', 'calories': 64},
    {'name': 'Strawberries', 'quantity': '1 cup (152 g)', 'calories': 49},
    {'name': 'Black Beans', 'quantity': '1 cup cooked (172 g)', 'calories': 227},
    {'name': 'Yogurt (plain)', 'quantity': '1 cup (245 g)', 'calories': 149},
    {'name': 'Dates', 'quantity': '2 pieces (48 g)', 'calories': 133},
    {'name': 'Cashews', 'quantity': '1 oz (28 g)', 'calories': 157},
    {'name': 'Pineapple', 'quantity': '1 cup chunks (165 g)', 'calories': 82},
    {'name': 'Peas', 'quantity': '1 cup (160 g)', 'calories': 117},
    {'name': 'Grapes', 'quantity': '1 cup (151 g)', 'calories': 104},
    {'name': 'Cabbage', 'quantity': '1 cup chopped (89 g)', 'calories': 22},
    {'name': 'Watermelon', 'quantity': '1 cup diced (152 g)', 'calories': 46},
    {'name': 'Leeks', 'quantity': '1 cup (89 g)', 'calories': 54},
    {'name': 'Turnip Greens', 'quantity': '1 cup cooked (144 g)', 'calories': 29},
    {'name': 'Butternut Squash', 'quantity': '1 cup cubed (205 g)', 'calories': 82},
    {'name': 'Artichokes', 'quantity': '1 medium (120 g)', 'calories': 60},
    {'name': 'Celery', 'quantity': '1 cup chopped (101 g)', 'calories': 16},
    {'name': 'Navy Beans', 'quantity': '1 cup cooked (182 g)', 'calories': 255},
    {'name': 'Radish', 'quantity': '1 cup sliced (116 g)', 'calories': 19},
    {'name': 'Onion', 'quantity': '1 medium (110 g)', 'calories': 44},
    {'name': 'Garlic', 'quantity': '1 clove (3 g)', 'calories': 5},
    {'name': 'Lima Beans', 'quantity': '1 cup (170 g)', 'calories': 209},
    {'name': 'Figs', 'quantity': '2 pieces (80 g)', 'calories': 74},
    {'name': 'Pomegranate', 'quantity': '1/2 fruit (154 g)', 'calories': 72},
    {'name': 'Cranberries', 'quantity': '1 cup (100 g)', 'calories': 46},
    {'name': 'Rutabaga', 'quantity': '1 cup (140 g)', 'calories': 50},
    {'name': 'Bok Choy', 'quantity': '1 cup cooked (170 g)', 'calories': 20},
    {'name': 'Swiss Chard', 'quantity': '1 cup cooked (175 g)', 'calories': 35},
    {'name': 'Mustard Greens', 'quantity': '1 cup cooked (140 g)', 'calories': 21},
    {'name': 'Soy Milk', 'quantity': '1 cup (243 g)', 'calories': 100},
    {'name': 'Fortified Cereal', 'quantity': '1 cup (30 g)', 'calories': 110},
    {'name': 'Pumpkin Puree', 'quantity': '1/2 cup (122 g)', 'calories': 42},
    {'name': 'Macadamia Nuts', 'quantity': '1 oz (28 g)', 'calories': 204},
    {'name': 'Hazelnuts', 'quantity': '1 oz (28 g)', 'calories': 178},
    {'name': 'Brazil Nuts', 'quantity': '1 oz (28 g)', 'calories': 187},
    {'name': 'Grapefruit', 'quantity': '1/2 fruit (123 g)', 'calories': 52},
    {'name': 'Cantaloupe', 'quantity': '1 cup diced (160 g)', 'calories': 54},
    {'name': 'Tangerine', 'quantity': '1 medium (109 g)', 'calories': 47},
    {'name': 'Lime', 'quantity': '1 fruit (67 g)', 'calories': 20},
    {'name': 'Papaya', 'quantity': '1 cup (140 g)', 'calories': 55},
    {'name': 'Honeydew', 'quantity': '1 cup diced (170 g)', 'calories': 61},
    {'name': 'Persimmon', 'quantity': '1 medium (168 g)', 'calories': 118},
    {'name': 'Plantains', 'quantity': '1 cup sliced (148 g)', 'calories': 181},
    {'name': 'Okra', 'quantity': '1 cup (100 g)', 'calories': 33},
    {'name': 'Scallions', 'quantity': '1 cup chopped (100 g)', 'calories': 32},
    {'name': 'Tempeh', 'quantity': '1 cup (166 g)', 'calories': 320},
    {'name': 'Liver (beef)', 'quantity': '3 oz (85 g)', 'calories': 153},
    {'name': 'Shrimp', 'quantity': '3 oz (85 g)', 'calories': 84},
    {'name': 'Tilapia', 'quantity': '3 oz (85 g)', 'calories': 111},
    {'name': 'Turkey Breast', 'quantity': '3 oz (85 g)', 'calories': 125},
    {'name': 'Ground Beef (lean)', 'quantity': '3 oz (85 g)', 'calories': 213},
    {'name': 'Duck Meat', 'quantity': '3 oz (85 g)', 'calories': 170},
    {'name': 'Venison', 'quantity': '3 oz (85 g)', 'calories': 134},
    {'name': 'Lamb', 'quantity': '3 oz (85 g)', 'calories': 250},
  ];


  List<Map<String, dynamic>> _filteredFoodItems = [];
  List<Map<String, dynamic>> _recentItems = [];
  int _currentCalories = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _currentCalories = 0;
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isNotEmpty) {
        _isSearching = true;
        _filteredFoodItems = _foodItems
            .where((food) => food['name'].toLowerCase().contains(_searchController.text.toLowerCase()))
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
    setState(() {
      _recentItems.add(food);
      _recentCount++;
      _currentCalories += (food['calories'] as num).toInt();
      widget.onAddItem(food);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food added successfully')),
      );
    });
  }

  void _removeFromRecent(Map<String, dynamic> food) {
    setState(() {
      _recentItems.remove(food);
      _recentCount--;
      _currentCalories -= (food['calories'] as num).toInt();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food deleted successfully')),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF5AA189),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            color: Color(0xFF5AA189),
            child: SafeArea(
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
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
                      '$_currentCalories/${widget.recommendedCalories} Cal',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
                actions: [
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.apple, color: Colors.white),
                        onPressed: () {
                          print('Apple icon tapped');
                        },
                      ),
                      if (_recentCount > 0)
                        Positioned(
                          right: 8.w,
                          top: 8.h,
                          child: CircleAvatar(
                            radius: 8.r,
                            backgroundColor: Colors.red,
                            child: Text(
                              _recentCount.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 10.sp),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                flexibleSpace: Container(color: Color(0xFF5AA189)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a food',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: _isSearching
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
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
                      color: Color(0xFF5AA189),
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
                    tabs: [
                      Tab(text: 'Recent'),
                      Tab(text: 'My food'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      RecentTabScreen(
                        recentItems: _recentItems,
                        onRemove: _removeFromRecent,
                      ),
                      MyFoodTabScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}