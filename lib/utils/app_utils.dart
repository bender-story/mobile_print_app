import 'dart:math';

class AppUtils{
  static String generateRandomFiveDigitNumber() {
    Random random = Random();
    return (random.nextInt(90000) + 10000).toString(); // Ensures the number is between 10000 and 99999
  }
}