import 'package:flutter/material.dart';
import 'package:signup/Meeting.dart';
import 'package:signup/common/widgets/app_bar.dart';
import 'package:signup/common/widgets/app_text_field.dart';
import 'package:signup/common/widgets/meeting_card.dart';
import 'package:signup/common/widgets/pill_button.dart';
import 'package:signup/objectbox.g.dart'; // Import the generated ObjectBox code
import 'package:signup/util/date_time_utils.dart';
import 'package:signup/util/meeting_store.dart';
import 'package:signup/util/validators.dart';

class SearchMeetingPage extends StatefulWidget {
  @override
  _SearchMeetingPageState createState() => _SearchMeetingPageState();
}

class _SearchMeetingPageState extends State<SearchMeetingPage> {
  final _searchFormKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;

  final MeetingStore _meetingStore = MeetingStore();
  List<Meeting> _searchResults = []; // State variable for search results

  @override
  void initState() {
    super.initState();
    _meetingStore.open(); // Initialize ObjectBox
  }

  @override
  void dispose() {
    _meetingStore.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppScreenAppBar(title: 'Search Meetings'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _searchFormKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _dateController,
                    label: 'Date',
                    readOnly: true,
                    validator: (value) => Validators.selection(value, 'date'),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _selectDate,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PillButton(label: 'Search', onPressed: _searchMeetings),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(child: Text('No meetings found.'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) =>
                          MeetingCard(meeting: _searchResults[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await pickDate(context, _selectedDate);

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = formatDate(pickedDate);
      });
    }
  }

  Future<void> _searchMeetings() async {
    if (_searchFormKey.currentState?.validate() ?? false) {
      final searchDate = _dateController.text;
      if (searchDate.isNotEmpty) {
        // Query the database for meetings with the exact date
        final query = _meetingStore.box
            .query(
              Meeting_.date.equals(searchDate),
            )
            .build();

        final meetings = query.find();

        setState(() {
          _searchResults = meetings;
        });
      }
    }
  }
}
