import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:signup/objectbox_store.dart';
import 'package:signup/theme/theme.dart';
import 'package:signup/util/utils.dart';
import '../../../Meeting.dart'; // Adjust the import according to your project structure

class MeetingListPage extends StatefulWidget {
  @override
  _MeetingListPageState createState() => _MeetingListPageState();
}

class _MeetingListPageState extends State<MeetingListPage> {
  Box<Meeting>? _meetingBox;
  List<Meeting> _meetings = []; // State variable for meetings
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final box = _meetingBox ??= await ObjectBoxStore.meetingBox();
      final meetings = box.getAll();
      if (!mounted) return;
      setState(() {
        _meetings = meetings;
        _loading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Failed to load meetings: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load meetings: $error';
      });
    }
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMeetings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_meetings.isEmpty) {
      return Center(child: Text('No meetings yet.'));
    }
    return ListView.builder(
      itemCount: _meetings.length,
      itemBuilder: (context, index) {
        final meeting = _meetings[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(meeting.subject),
            subtitle: Text('${formatMeetingDate(meeting.date)} ${meeting.time}'),
            onTap: () => _showMeetingDetails(context, meeting),
          ),
        );
      },
    );
  }

  void _showMeetingDetails(BuildContext context, Meeting meeting) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(meeting.subject),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${formatMeetingDate(meeting.date)}'),
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
