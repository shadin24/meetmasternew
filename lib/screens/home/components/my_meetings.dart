import 'package:flutter/material.dart';
import 'package:signup/Meeting.dart';
import 'package:signup/common/widgets/app_bar.dart';
import 'package:signup/common/widgets/meeting_card.dart';
import 'package:signup/util/meeting_store.dart';

class MeetingListPage extends StatefulWidget {
  @override
  _MeetingListPageState createState() => _MeetingListPageState();
}

class _MeetingListPageState extends State<MeetingListPage> {
  final MeetingStore _meetingStore = MeetingStore();
  List<Meeting> _meetings = []; // State variable for meetings

  @override
  void initState() {
    super.initState();
    _initStore(); // Initialize ObjectBox
  }

  Future<void> _initStore() async {
    await _meetingStore.open();
    _loadMeetings(); // Load meetings from ObjectBox
  }

  Future<void> _loadMeetings() async {
    final meetings = _meetingStore.box.getAll();
    setState(() {
      _meetings = meetings;
    });
  }

  @override
  void dispose() {
    _meetingStore.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppScreenAppBar(title: 'Upcoming Meetings'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _meetings.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _meetings.length,
                itemBuilder: (context, index) =>
                    MeetingCard(meeting: _meetings[index]),
              ),
      ),
    );
  }
}
