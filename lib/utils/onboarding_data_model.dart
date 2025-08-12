
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
class Sliders {
  final String? image;
  final String? name;
  final String? title;

  Sliders({this.image, this.name, this.title});
}

class User {
  final String? name;
  final String? image;
  final String? email;
  final String? phoneNo;

  User({this.name, this.image, this.email, this.phoneNo});
}

class Utils {
  static List<User> getUser() {
    return [
      User(
          name: "Kevin",
          image: "assets/person.png",
          email: "sdsdsd123@gmail.com",
          phoneNo: '1234567895'),
    ];
  }

  static List<Sliders> getSliderPages(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      Sliders(
        image: 'assets/images/gdm_Logos.png',
        name: l10n.welcomeToGDMCareHub,
        title: l10n.welcomeToGDMCareHubDescription,
      ),
      Sliders(
        image: 'assets/images/gdm_Logos.png',
        name: l10n.understandingDiabetes,
        title: l10n.understandingDiabetesDescription,
      ),
      Sliders(
        image: 'assets/images/gdm_Logos.png',
        name: l10n.type2Diabetes,
        title: l10n.type2DiabetesDescription,
      ),
      Sliders(
        image: 'assets/images/gdm_Logos.png',
        name: l10n.risksOfGestationalDiabetes,
        title: l10n.risksOfGestationalDiabetesDescription,
      ),
    ];
  }
}