import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'food_list_screen.dart';
import 'recent_tab_screen.dart';
import 'my_food_tab_screen.dart';

class MealsTabBarScreen extends StatefulWidget {
  final String mealType;
  final int recommendedCalories;

  const MealsTabBarScreen({Key? key, required this.mealType, required this.recommendedCalories}) : super(key: key);

  @override
  _MealsTabBarScreenState createState() => _MealsTabBarScreenState();
}

class _MealsTabBarScreenState extends State<MealsTabBarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  int _recentCount = 0;

  final List<Map<String, dynamic>> _foodItems = [
    {'name': 'Coffee', 'quantity': '1 Cup (237 g)', 'calories': 2},
    {'name': 'Iced coffee', 'quantity': '1 Cup (237 g)', 'calories': 2},
    {'name': 'Scone', 'quantity': '1 Whole (57 g)', 'calories': 169},
    {'name': 'Decaf coffee', 'quantity': '1 Cup (237 g)', 'calories': 0},
    {'name': 'Lychee', 'quantity': '1 Whole (9.60 g)', 'calories': 6},
    {'name': 'Instant coffee', 'quantity': '1 Serving (5 g)', 'calories': 0},
    {'name': 'Turkish coffee', 'quantity': '1 Cup (237 g)', 'calories': 2},
    {'name': 'Microgreens', 'quantity': '1 Serving (60 g)', 'calories': 14},
    {'name': 'Coffee beans', 'quantity': '1 Tablespoon (5 g)', 'calories': 18},
    {'name': '100% Columbian ground coffee medium roast, Dunkin', 'quantity': '1 Serving (312 g)', 'calories': 0},
    {'name': 'Coffee creamer', 'quantity': '1 Tablespoon (15 g)', 'calories': 20},
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
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Color(0xFF5AA189),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFF5AA189),
                    indicatorWeight: 3.0,
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