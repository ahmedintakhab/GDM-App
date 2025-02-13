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
        name: 'Manage Stress, Control Sugar!',
        title: 'High stress levels can spike blood sugar—practice mindfulness and relaxation.',
      ),
      Sliders(
        image: 'assets/images/onboarding3.jpg',
        name: 'Hormonal Balance Matters!',
        title: 'Understand your hormones to maintain a healthy and balanced lifestyle.',
      ),
      Sliders(
        image: 'assets/images/onboarding2.jpg',
        name: 'Balance Your Blood Sugar!',
        title: 'Maintain healthy glucose levels with a balanced diet and active lifestyle.',
      ),
      Sliders(
        image: 'assets/images/onboarding4.jpg',
        name: 'Regular Checkups, Better Health!',
        title: 'Early detection is the best prevention—schedule your screenings today.',

      ),
    ];
  }
}