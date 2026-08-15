import 'package:flutter/material.dart';
import 'package:signup/Meeting.dart';
import 'package:signup/util/date_time_utils.dart';

/// List entry summarising a meeting, opening its details on tap.
class MeetingCard extends StatelessWidget {
  const MeetingCard({Key? key, required this.meeting}) : super(key: key);

  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(meeting.subject),
        subtitle: Text('${formatStoredDate(meeting.date)} ${meeting.time}'),
        onTap: () => showMeetingDetails(context, meeting),
      ),
    );
  }
}

void showMeetingDetails(BuildContext context, Meeting meeting) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(meeting.subject),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${formatStoredDate(meeting.date)}'),
              Text('Time: ${meeting.time}'),
              Text('Location: ${meeting.location}'),
              Text('Category: ${meeting.category}'),
              Text('Participants: ${meeting.participants.join(', ')}'),
              const SizedBox(height: 10),
              const Text('Agenda:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(meeting.agenda),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
