import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;

  @Unique()
  String email;

  /// Base64 encoded PBKDF2-HMAC-SHA256 hash of the password.
  String passwordHash;

  /// Base64 encoded random salt used to derive [passwordHash].
  String salt;

  int iterations;

  User({
    this.email = '',
    this.passwordHash = '',
    this.salt = '',
    this.iterations = 0,
  });
}
