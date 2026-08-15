import 'package:flutter_test/flutter_test.dart';
import 'package:signup/util/utils.dart';

void main() {
  group('Utils.isValidEmail', () {
    test('accepts common address shapes', () {
      expect(Utils.isValidEmail('user@example.com'), isTrue);
      expect(Utils.isValidEmail('first.last@example.co.uk'), isTrue);
      expect(Utils.isValidEmail('user_name@example-mail.com'), isTrue);
      expect(Utils.isValidEmail('user-name@sub.example.info'), isTrue);
      expect(Utils.isValidEmail('123@456.dev'), isTrue);
    });

    test('rejects addresses with a missing or malformed local part', () {
      expect(Utils.isValidEmail(''), isFalse);
      expect(Utils.isValidEmail('@example.com'), isFalse);
      expect(Utils.isValidEmail('user name@example.com'), isFalse);
      expect(Utils.isValidEmail('user+tag@example.com'), isFalse);
    });

    test('rejects addresses with a missing or malformed domain', () {
      expect(Utils.isValidEmail('user@'), isFalse);
      expect(Utils.isValidEmail('user'), isFalse);
      expect(Utils.isValidEmail('user@example'), isFalse);
      expect(Utils.isValidEmail('user@@example.com'), isFalse);
    });

    test('rejects top level domains outside the 2-4 character range', () {
      expect(Utils.isValidEmail('user@example.c'), isFalse);
      expect(Utils.isValidEmail('user@example.technology'), isFalse);
      expect(Utils.isValidEmail('user@example.c0m'), isFalse);
    });

    test('rejects addresses with surrounding text', () {
      expect(Utils.isValidEmail(' user@example.com'), isFalse);
      expect(Utils.isValidEmail('user@example.com '), isFalse);
      expect(Utils.isValidEmail('mail to user@example.com now'), isFalse);
    });
  });
}
