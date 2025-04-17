import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/help%20center/information_dialogbox.dart';
import 'information_card.dart'; // Import the second file

// Static data for card titles and their details
final Map<String, String> cardDetails = {
  "What is GDM?":
  "Gestational Diabetes Mellitus (GDM) is a condition where a pregnant woman "
      "develops high blood sugar levels. "
      "It usually occurs during the second or third "
      "trimester and resolves after delivery. "
      "It requires careful monitoring to ensure the health of both mother and baby.",
  "Who is at Risk?":
  "You are at higher risk if you:\n1. Have a family history of diabetes\n2. "
      "Are overweight/obese or have a sedentary lifestyle\n3."
      " Are older than 35 years\n4. Have had GDM in a previous pregnancy\n5."
      " Have polycystic ovary syndrome (PCOS)\n6. "
      "Belong to an ethnic group with a high diabetes risk"
      " (including Middle Eastern populations)",
  "Signs & Symptoms":
"Most women do not have symptoms, so screening is essential. Some may experience:\n●"
    " Increased thirst and frequent urination\n● Fatigue\n● Blurred vision",
  "Screening & Diagnosis":
"In the UAE:\n1. Screening for GDM is recommended between 24-28 weeks of pregnancy."
    "\n2. A glucose tolerance test (OGTT) is used for diagnosis.",
  "Complications of GDM":
  "⚠️ If left uncontrolled, GDM can lead to:\n1. "
      "High birth weight in babies (macrosomia)\n2."
      " Preterm birth or C-section delivery\n3. "
      "Preeclampsia (high blood pressure during pregnancy)\n4."
      " Increased risk of Type 2 Diabetes for both mother & child later in life",
  "Managing GDM":
  "1 Healthy eating\n. Follow a balanced meal plan with whole grains, lean protein, and fiber\n"
      "2 Regular physical activity\n. Aim for 30 minutes of moderate exercise (e.g., walking)\n"
      "3 Blood sugar monitoring\n. Check your glucose levels as advised by your doctor\n"
      "4 Medications\n. If needed, insulin or other treatments may be prescribed",
  "Postpartum Care":
"1. GDM usually resolves after birth, but women with GDM have a 50% risk of developing Type 2 Diabetes in the future\n"
"2. Breastfeeding helps regulate blood sugar and lowers future diabetes risk\n"
"3. A follow-up diabetes test is recommended 6-12 weeks postpartum and every 1-3 years thereafter",
  "Prevention of GDM – UAE-Specific Tips":
"1. Healthy Eating for GDM Prevention\n"
"● Choose Nutrient-Rich UAE-Friendly Foods\n"
". Opt for whole-wheat Arabic bread, brown rice, quinoa, and oats instead of white bread or refined grains\n"
". Include grilled fish (like hammour or salmon), chicken, lean lamb, and plant-based proteins like lentils, chickpeas, and fava beans (foul)\n"
". Use olive oil and nuts (almonds, walnuts, pistachios) instead of excessive butter or ghee\n"
". Enjoy local fiber-rich options like dates (in moderation), cucumbers, tomatoes, okra, and zucchini\n"
". Choose low-fat Laban, Greek yogurt, or Ayran instead of full-fat dairy\n"
"● Foods to Limit\n"
". Limit high-carb Emirati dishes (e.g., excess white rice in biryani or Harees – opt for whole-grain versions)\n"
". Avoid sugary beverages (e.g., Karak tea with sugar, soft drinks, fruit juices – replace with unsweetened tea or infused water)\n"
". Reduce desserts and sweets (e.g., Luqaimat, Baklava – enjoy in moderation and opt for healthier alternatives like dates with nuts)\n"
"2. Staying Active in the UAE Climate\n"
"● Exercise Tips Despite the Heat\n"
". Walk indoors in malls (e.g., Mall of the Emirates, Yas Mall) or indoor gyms\n"
". Try swimming, a great low-impact option for pregnancy-friendly fitness\n"
". Take evening outdoor walks at parks like Al Barsha Pond Park, Safa Park, or Corniche when it’s cooler\n"
". Join prenatal yoga or Pilates classes, offered at many gyms and maternity centers with women-only options\n"
"3. Managing Cultural & Social Eating Habits\n"
"● Smart Choices at Gatherings\n"
". Practice portion control: enjoy small portions of rice and bread, filling up on grilled meats and vegetables\n"
". Make healthy swaps: replace fried samosas with baked versions or grilled meats\n"
". Choose balanced Iftar meals: avoid excessive sweets after Iftar; opt for fruit, Laban, or nuts instead\n"
". Stay hydrated: drink plenty of water instead of sweetened juices",

};
// Static data for GDM containers
final List<Map<String, String>> gdmContainers = [
  {
    'title': 'Understanding Gestational Diabetes (GDM)',
    'description':
    'A comprehensive overview of GDM, its causes, risk factors, and how it affects pregnancy.',
  },
  {
    'title': 'GDM and Pregnancy',
    'description':
    'Key facts about GDM, screening processes, and long-term health implications.',
  },
];


class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  String _searchQuery = '';
  List<String> _filteredTitles = [];
  @override
  void initState() {
    super.initState();
    // Initialize with all titles
    _filteredTitles = cardDetails.keys.toList();
  }
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredTitles = cardDetails.keys.toList();
      } else {
        _filteredTitles = cardDetails.keys
            .where((title) =>
            title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        // Sort to prioritize exact or closer matches
        _filteredTitles.sort((a, b) {
          final aMatch = a.toLowerCase().indexOf(query.toLowerCase());
          final bMatch = b.toLowerCase().indexOf(query.toLowerCase());
          return aMatch.compareTo(bMatch);
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Help Center",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF5AA189),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search by topics",
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0XFF5AA189),
                    size: 20.w,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _buildGDMContainer(
                      title: gdmContainers[0]['title']!,
                      description: gdmContainers[0]['description']!,
                      onTap: (){
                        showDialog(context: context, builder:
                            (context)=>InformationDialogbox(title: gdmContainers[0]['title']!,
                                description: gdmContainers[0]['description']!));
                      }
                    )

                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                      child: _buildGDMContainer(
                          title: gdmContainers[1]['title']!,
                          description: gdmContainers[1]['description']!,
                          onTap: (){
                            showDialog(context: context, builder:
                                (context)=>InformationDialogbox(title: gdmContainers[1]['title']!,
                                description: gdmContainers[1]['description']!));
                          }
                      )

                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "GDM Assistance + HUB",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF5AA189),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ..._filteredTitles.map((title) => Column(
                      children: [
                        InformationCard(
                          title: title,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationDetailsScreen(
                                  title: title,
                                  details: cardDetails[title]!,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8.h),
                      ],
                    )).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGDMContainer({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        constraints: BoxConstraints(
          minHeight: 120.h
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
               maxLines: 2,
               overflow: TextOverflow.ellipsis,

            ),
            if (description.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                maxLines: 6, // Limit description lines
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
    ]
      ),

    )

    );
  }
}