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
  int _recentCount = 0;

  final List<Map<String, dynamic>> _foodItems = [
    {'name': 'Tofu', 'quantity': '3 oz (85 g)', 'calories': 70},
    {'name': 'Almonds', 'quantity': '1 oz (28 g)', 'calories': 164},
    {'name': 'Banana', 'quantity': '1 medium (118 g)', 'calories': 105},
    // ... (other food items unchanged for brevity)
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
        const SnackBar(content: Text('Food added successfully')),
      );
    });
  }

  void _removeFromRecent(Map<String, dynamic> food) {
    setState(() {
      _recentItems.remove(food);
      _recentCount--;
      _currentCalories -= (food['calories'] as num).toInt();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food deleted successfully')),
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
                      '$_currentCalories/${widget.recommendedCalories} Cal',
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
                      RecentTabScreen(
                        recentItems: _recentItems,
                        onRemove: _removeFromRecent,
                      ),
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
  }
}