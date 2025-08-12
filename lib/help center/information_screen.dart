import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdm_app/help%20center/information_dialogbox.dart';
import 'information_card.dart'; // Import the second file
import '../l10n/app_localizations.dart';


// Static data for card titles and their details using ARB keys
final Map<String, String> cardDetails = {
  'whatIsGDM': 'whatIsGDMDescription',
  'whoIsAtRisk': 'whoIsAtRiskDescription',
  'signsAndSymptoms': 'signsAndSymptomsDescription',
  'screeningAndDiagnosis': 'screeningAndDiagnosisDescription',
  'complicationsOfGDM': 'complicationsOfGDMDescription',
  'managingGDM': 'managingGDMDescription',
  'postpartumCare': 'postpartumCareDescription',
  'preventionOfGDM': 'preventionOfGDMDescription',
};
// Static data for GDM containers using ARB keys
final List<Map<String, String>> gdmContainers = [
  {
    'title': 'understandingGDM',
    'description': 'understandingGDMDescription',
  },
  {
    'title': 'gdmAndPregnancy',
    'description': 'gdmAndPregnancyDescription',
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

  // Helper method to map ARB keys to AppLocalizations properties
  String _getLocalizedString(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'whatIsGDM':
        return l10n.whatIsGDM;
      case 'whatIsGDMDescription':
        return l10n.whatIsGDMDescription;
      case 'whoIsAtRisk':
        return l10n.whoIsAtRisk;
      case 'whoIsAtRiskDescription':
        return l10n.whoIsAtRiskDescription;
      case 'signsAndSymptoms':
        return l10n.signsAndSymptoms;
      case 'signsAndSymptomsDescription':
        return l10n.signsAndSymptomsDescription;
      case 'screeningAndDiagnosis':
        return l10n.screeningAndDiagnosis;
      case 'screeningAndDiagnosisDescription':
        return l10n.screeningAndDiagnosisDescription;
      case 'complicationsOfGDM':
        return l10n.complicationsOfGDM;
      case 'complicationsOfGDMDescription':
        return l10n.complicationsOfGDMDescription;
      case 'managingGDM':
        return l10n.managingGDM;
      case 'managingGDMDescription':
        return l10n.managingGDMDescription;
      case 'postpartumCare':
        return l10n.postpartumCare;
      case 'postpartumCareDescription':
        return l10n.postpartumCareDescription;
      case 'preventionOfGDM':
        return l10n.preventionOfGDM;
      case 'preventionOfGDMDescription':
        return l10n.preventionOfGDMDescription;
      case 'understandingGDM':
        return l10n.understandingGDM;
      case 'understandingGDMDescription':
        return l10n.understandingGDMDescription;
      case 'gdmAndPregnancy':
        return l10n.gdmAndPregnancy;
      case 'gdmAndPregnancyDescription':
        return l10n.gdmAndPregnancyDescription;
      default:
        return key; // Fallback to the key itself if not found
    }
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                l10n.helpCenter,
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
                  hintText: l10n.searchByTopics,
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => InformationDialogbox(
                            title: _getLocalizedString(
                                context, gdmContainers[0]['title']!),
                            description: _getLocalizedString(
                                context, gdmContainers[0]['description']!),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildGDMContainer(
                      title: gdmContainers[1]['title']!,
                      description: gdmContainers[1]['description']!,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => InformationDialogbox(
                            title: _getLocalizedString(
                                context, gdmContainers[1]['title']!),
                            description: _getLocalizedString(
                                context, gdmContainers[1]['description']!),
                          ),
                        );
                      },
                    ),
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
                      l10n.gdmAssistanceHub,
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
                          title: _getLocalizedString(context, title),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationDetailsScreen(
                                  title: _getLocalizedString(context, title),
                                  details: _getLocalizedString(
                                      context, cardDetails[title]!),
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
              _getLocalizedString(context, title),
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
                _getLocalizedString(context, description),
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