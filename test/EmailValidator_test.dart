import 'package:flutter_test/flutter_test.dart';
import 'package:uBookSharing/Screens/Auth/LoginScreen.dart';

void main() {
  // setUp(() {});
  // tearDown(() {});
  group("Email Field Test", () {
    test("Empty Field returns error", () {
      var result = EmailValidator.validator('');

      expect(result, "Enter email address");
    });
    test("Null returns error", () {
      var result = EmailValidator.validator(null);

      expect(result, "Enter email address");
    });

    test("Valid Email", () {
      
      var result = EmailValidator.validator('sourav.ahmed5654@gmail.com');
      expect(result, null);
    });

    test("RegEx email validator test", () {
      var result = EmailValidator.validator("12345432345");
      expect(result, 'Invalid Email');
    });
  });
}
