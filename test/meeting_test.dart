import 'package:flutter_test/flutter_test.dart';
import 'package:signup/Meeting.dart';

void main() {
  group('Meeting constructor', () {
    test('defaults every field when no arguments are given', () {
      final meeting = Meeting();

      expect(meeting.id, 0);
      expect(meeting.subject, '');
      expect(meeting.meetingId, '');
      expect(meeting.location, '');
      expect(meeting.date, '');
      expect(meeting.time, '');
      expect(meeting.category, '');
      expect(meeting.participantsCount, 0);
      expect(meeting.agenda, '');
      expect(meeting.participants, isEmpty);
      expect(meeting.participantsSerialized, '');
    });

    test('keeps the provided values', () {
      final meeting = Meeting(
        subject: 'Sprint review',
        meetingId: 'MTG-1',
        location: 'Room 2',
        date: '2024-08-15',
        time: '10:30',
        category: 'Internal',
        participantsCount: 2,
        agenda: 'Demo',
        participants: ['ann', 'bob'],
      );

      expect(meeting.subject, 'Sprint review');
      expect(meeting.meetingId, 'MTG-1');
      expect(meeting.location, 'Room 2');
      expect(meeting.date, '2024-08-15');
      expect(meeting.time, '10:30');
      expect(meeting.category, 'Internal');
      expect(meeting.participantsCount, 2);
      expect(meeting.agenda, 'Demo');
      expect(meeting.participants, ['ann', 'bob']);
    });

    test('serializes participants passed to the constructor', () {
      expect(Meeting(participants: ['ann', 'bob']).participantsSerialized,
          'ann,bob');
      expect(Meeting(participants: ['solo']).participantsSerialized, 'solo');
      expect(Meeting(participants: []).participantsSerialized, '');
    });
  });

  group('Meeting.updateParticipants', () {
    test('replaces both the list and its serialized form', () {
      final meeting = Meeting(participants: ['ann']);

      meeting.updateParticipants(['bob', 'cara']);

      expect(meeting.participants, ['bob', 'cara']);
      expect(meeting.participantsSerialized, 'bob,cara');
    });

    test('clears the serialized form for an empty list', () {
      final meeting = Meeting(participants: ['ann', 'bob']);

      meeting.updateParticipants([]);

      expect(meeting.participants, isEmpty);
      expect(meeting.participantsSerialized, '');
    });
  });

  group('Meeting.readParticipants', () {
    test('restores the list from the serialized form', () {
      final meeting = Meeting()..participantsSerialized = 'ann,bob,cara';

      meeting.readParticipants();

      expect(meeting.participants, ['ann', 'bob', 'cara']);
    });

    test('round-trips through updateParticipants', () {
      final source = Meeting()..updateParticipants(['ann', 'bob']);
      final restored = Meeting()
        ..participantsSerialized = source.participantsSerialized
        ..readParticipants();

      expect(restored.participants, source.participants);
    });

    test('yields a single empty entry for an empty serialized form', () {
      final meeting = Meeting();

      meeting.readParticipants();

      expect(meeting.participants, ['']);
    });
  });
}
