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

  static List<Sliders> getSliderPages() {
    return [
      Sliders(
        image: 'assets/images/onboarding1.jpg',
        name: 'Welcome to GDMCare+ Hub',
        title: 'Welcome to GDMCare+ Hub – your go-to platform for managing diabetes in pregnancy and empowering everyone with diabetes awareness!',
      ),
      Sliders(
        image: 'assets/images/onboarding3.jpg',
        name: 'Understanding Diabetes',
        title: 'Diabetes is a chronic condition where the body struggles to control blood sugar levels.',
      ),
      Sliders(
        image: 'assets/images/onboarding2.jpg',
        name: 'Type 2 Diabetes',
        title: 'Type 2 diabetes is the most common form, often linked to poor diet and lack of exercise.',
      ),
      Sliders(
        image: 'assets/images/onboarding4.jpg',
        name: 'Risks of Gestational Diabetes',
        title: 'It increases the risk of complications for both mother and baby, and future Type 2 diabetes.',

      ),
    ];
  }
}