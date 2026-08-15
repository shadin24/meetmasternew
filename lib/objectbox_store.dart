import 'package:signup/Meeting.dart';
import 'package:signup/objectbox.g.dart';

/// Owns the single ObjectBox [Store] used by the whole app.
///
/// ObjectBox only allows one open [Store] per directory, so every screen shares
/// this instance instead of opening (and closing) its own. A failed open is not
/// cached: the error is rethrown to the caller and the next call retries.
class ObjectBoxStore {
  ObjectBoxStore._();

  static Future<Store>? _opening;
  static Store? _store;

  static Future<Store> getInstance() {
    final store = _store;
    if (store != null) {
      return Future.value(store);
    }
    return _opening ??= openStore().then((opened) {
      _store = opened;
      return opened;
    }, onError: (Object error, StackTrace stackTrace) {
      _opening = null;
      Error.throwWithStackTrace(error, stackTrace);
    });
  }

  static Future<Box<Meeting>> meetingBox() async {
    final store = await getInstance();
    return store.box<Meeting>();
  }

  /// Closes the shared store. Intended for tests and app shutdown; individual
  /// screens must not close a store they do not own.
  static void close() {
    _store?.close();
    _store = null;
    _opening = null;
  }
}
