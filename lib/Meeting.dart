import 'package:objectbox/objectbox.dart';

@Entity()
class Meeting {
  @Id()
  int id = 0; // Automatically incremented ID

  String subject;
  String meetingId;
  String location;
  String date;
  String time;
  String category;
  int participantsCount;
  String agenda;

  // Store serialized participants as a String
  String participantsSerialized = '';

  @Transient()
  List<String> participants = [];

  Meeting({
    this.subject = '',
    this.meetingId = '',
    this.location = '',
    this.date = '',
    this.time = '',
    this.category = '',
    this.participantsCount = 0,
    this.agenda = '',
    List<String>? participants,
  }) {
    if (participants != null) {
      this.participants = participants;
      participantsSerialized = participants.join(',');
    }
  }

  // Method to update participants and serialized string
  void updateParticipants(List<String> participants) {
    this.participants = participants;
    participantsSerialized = participants.join(',');
  }

  // Method to read participants from serialized string
  void readParticipants() {
    participants = participantsSerialized.split(',');
  }
}
