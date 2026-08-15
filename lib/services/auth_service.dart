import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:signup/objectbox.g.dart';
import 'package:signup/services/object_box.dart';
import 'package:signup/user.dart';

enum AuthResult { success, invalidCredentials, emailAlreadyRegistered }

class AuthService {
  static const int _iterations = 100000;
  static const int _saltLength = 16;
  static const int _keyLength = 32;

  final Box<User> _userBox;

  AuthService(this._userBox);

  static Future<AuthService> create() async {
    final objectBox = await ObjectBox.instance();
    return AuthService(objectBox.userBox);
  }

  Future<AuthResult> register(String email, String password) async {
    final normalizedEmail = _normalizeEmail(email);
    final existing =
        _userBox.query(User_.email.equals(normalizedEmail)).build();
    final alreadyRegistered = existing.count() > 0;
    existing.close();
    if (alreadyRegistered) {
      return AuthResult.emailAlreadyRegistered;
    }

    final salt = _generateSalt();
    final hash = await _deriveKeyAsync(password, salt, _iterations);
    _userBox.put(User(
      email: normalizedEmail,
      passwordHash: base64Encode(hash),
      salt: base64Encode(salt),
      iterations: _iterations,
    ));
    return AuthResult.success;
  }

  Future<AuthResult> login(String email, String password) async {
    final query = _userBox.query(User_.email.equals(_normalizeEmail(email))).build();
    final user = query.findFirst();
    query.close();
    if (user == null) {
      // Derive anyway so that unknown accounts take a comparable amount of
      // time as existing ones and cannot be enumerated by timing the response.
      await _deriveKeyAsync(password, _generateSalt(), _iterations);
      return AuthResult.invalidCredentials;
    }

    final candidate = await _deriveKeyAsync(
        password, base64Decode(user.salt), user.iterations);
    if (!_constantTimeEquals(candidate, base64Decode(user.passwordHash))) {
      return AuthResult.invalidCredentials;
    }
    return AuthResult.success;
  }

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  static Uint8List _generateSalt() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(_saltLength, (_) => random.nextInt(256)),
    );
  }

  /// Runs the key derivation off the UI isolate to keep the app responsive.
  static Future<Uint8List> _deriveKeyAsync(
          String password, Uint8List salt, int iterations) =>
      Isolate.run(() => deriveKey(password, salt, iterations));

  /// PBKDF2-HMAC-SHA256 (RFC 8018).
  @visibleForTesting
  static Uint8List deriveKey(String password, Uint8List salt, int iterations) {
    final hmac = Hmac(sha256, utf8.encode(password));
    final blockCount = (_keyLength / 32).ceil();
    final derived = Uint8List(blockCount * 32);

    for (var block = 1; block <= blockCount; block++) {
      final blockIndex = Uint8List(4)
        ..[0] = block >> 24
        ..[1] = block >> 16
        ..[2] = block >> 8
        ..[3] = block;
      var u = Uint8List.fromList(hmac.convert(salt + blockIndex).bytes);
      final result = Uint8List.fromList(u);
      for (var i = 1; i < iterations; i++) {
        u = Uint8List.fromList(hmac.convert(u).bytes);
        for (var j = 0; j < result.length; j++) {
          result[j] ^= u[j];
        }
      }
      derived.setRange((block - 1) * 32, block * 32, result);
    }
    return Uint8List.sublistView(derived, 0, _keyLength);
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
