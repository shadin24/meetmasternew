import 'package:signup/Meeting.dart';
import 'package:signup/objectbox.g.dart';

/// Owns the ObjectBox [Store] lifecycle and exposes the [Meeting] box.
class MeetingStore {
  Store? _store;
  Box<Meeting>? _box;

  Box<Meeting> get box {
    final box = _box;
    if (box == null) {
      throw StateError('MeetingStore.open() has not completed yet');
    }
    return box;
  }

  bool get isOpen => _box != null;

  Future<Box<Meeting>> open() async {
    final store = await openStore();
    _store = store;
    final box = store.box<Meeting>();
    _box = box;
    return box;
  }

  void close() {
    _store?.close();
    _store = null;
    _box = null;
  }
}
