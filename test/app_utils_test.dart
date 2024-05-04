import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_printer_app/utils/app_utils.dart';

void main() {
  group('AppUtils Tests', () {
    test('generateRandomFiveDigitNumber returns a five-digit number', () {
      String result = AppUtils.generateRandomFiveDigitNumber();

      // Check if the length is 5
      expect(result.length, 5);
    });
  });
}
