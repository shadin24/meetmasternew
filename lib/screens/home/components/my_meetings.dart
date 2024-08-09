import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:signup/objectbox.g.dart'; // Import the generated code
import 'package:signup/theme/theme.dart';
import '../../../Meeting.dart'; // Adjust the import according to your project structure

class MeetingListPage extends StatefulWidget {
  @override
  _MeetingListPageState createState() => _MeetingListPageState();
}

class _MeetingListPageState extends State<MeetingListPage> {
  late final Store _store;
  late final Box<Meeting> _meetingBox;
  List<Meeting> _meetings = []; // State variable for meetings

  @override
  void initState() {
    super.initState();
    _initStore(); // Initialize ObjectBox
  }

  Future<void> _initStore() async {
    _store = await openStore();
    _meetingBox = _store.box<Meeting>();
    _loadMeetings(); // Load meetings from ObjectBox
  }

  Future<void> _loadMeetings() async {
    final meetings = _meetingBox.getAll();
    setState(() {
      _meetings = meetings;
    });
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upcoming Meetings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _meetings.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _meetings.length,
          itemBuilder: (context, index) {
            final meeting = _meetings[index];
            final date = DateTime.parse(meeting.date); // Convert String to DateTime
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(meeting.subject),
                subtitle: Text(
                  '${DateFormat('yyyy-MM-dd').format(date)} ${meeting.time}',
                ),
                onTap: () => _showMeetingDetails(context, meeting),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showMeetingDetails(BuildContext context, Meeting meeting) {
    final date = DateTime.parse(meeting.date); // Convert String to DateTime

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(meeting.subject),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
                Text('Time: ${meeting.time}'),
                Text('Location: ${meeting.location}'),
                Text('Category: ${meeting.category}'),
                Text('Participants: ${meeting.participants.join(', ')}'),
                SizedBox(height: 10),
                Text('Agenda:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(meeting.agenda),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
