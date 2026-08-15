import 'package:signup/Meeting.dart';
import 'package:signup/objectbox.g.dart';
import 'package:signup/user.dart';

/// Single application wide ObjectBox store.
///
/// Opening the same store more than once throws, so every screen shares the
/// instance created here instead of calling `openStore()` on its own.
class ObjectBox {
  final Store store;

  late final Box<Meeting> meetingBox = store.box<Meeting>();
  late final Box<User> userBox = store.box<User>();

  ObjectBox._(this.store);

  static ObjectBox? _instance;

  static Future<ObjectBox> instance() async {
    return _instance ??= ObjectBox._(await openStore());
  }
}
