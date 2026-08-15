import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:signup/services/auth_service.dart';
import 'package:signup/util/utils.dart';

String _hex(List<int> bytes) =>
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

void main() {
  group('PBKDF2-HMAC-SHA256', () {
    test('matches published test vectors', () {
      expect(
        _hex(AuthService.deriveKey(
            'password', Uint8List.fromList(utf8.encode('salt')), 1)),
        '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
      );
      expect(
        _hex(AuthService.deriveKey(
            'password', Uint8List.fromList(utf8.encode('salt')), 2)),
        'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43',
      );
    });

    test('different salts produce different hashes', () {
      final a = AuthService.deriveKey(
          'hunter2A', Uint8List.fromList([1, 2, 3, 4]), 10);
      final b = AuthService.deriveKey(
          'hunter2A', Uint8List.fromList([4, 3, 2, 1]), 10);
      expect(_hex(a), isNot(_hex(b)));
    });
  });

  group('password policy', () {
    test('rejects short and non alphanumeric passwords', () {
      expect(Utils.validatePassword(''), isNotNull);
      expect(Utils.validatePassword('abc123'), isNotNull);
      expect(Utils.validatePassword('abcdefgh'), isNotNull);
      expect(Utils.validatePassword('12345678'), isNotNull);
    });

    test('accepts a compliant password', () {
      expect(Utils.validatePassword('abcdefg1'), isNull);
    });
  });

  group('email validation', () {
    test('accepts long and subdomained TLDs', () {
      expect(Utils.isValidEmail('user@example.technology'), isTrue);
      expect(Utils.isValidEmail('user+tag@mail.example.co.uk'), isTrue);
    });

    test('rejects malformed addresses', () {
      expect(Utils.isValidEmail('user@@example.com'), isFalse);
      expect(Utils.isValidEmail('user example.com'), isFalse);
    });
  });
}
