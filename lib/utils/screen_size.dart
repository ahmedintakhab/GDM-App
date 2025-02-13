import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double screenWidth = 0;
double screenHeight = 0;

void initializeScreenSize(BuildContext context) {
  ScreenUtil.init(context, designSize: const Size(375, 812));
  screenWidth = MediaQuery.of(context).size.width;
  screenHeight = MediaQuery.of(context).size.height;
}