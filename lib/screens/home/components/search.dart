import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:signup/objectbox.g.dart'; // Import the generated ObjectBox code
import 'package:signup/theme/theme.dart';
import '../../../Meeting.dart'; // Adjust the import according to your project structure

class SearchMeetingPage extends StatefulWidget {
  @override
  _SearchMeetingPageState createState() => _SearchMeetingPageState();
}

class _SearchMeetingPageState extends State<SearchMeetingPage> {
  final _searchFormKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;

  late final Store _store;
  late final Box<Meeting> _meetingBox;
  List<Meeting> _searchResults = []; // State variable for search results

  @override
  void initState() {
    super.initState();
    _initStore(); // Initialize ObjectBox
  }

  Future<void> _initStore() async {
    _store = await openStore();
    _meetingBox = _store.box<Meeting>();
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
          'Search Meetings',
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
        child: Column(
          children: [
            Form(
              key: _searchFormKey,
              child: Column(
                children: [
                  _buildDateField(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _searchMeetings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(child: Text('No meetings found.'))
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final meeting = _searchResults[index];
                  final date = DateTime.parse(meeting.date); // Convert String to DateTime
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(meeting.subject),
                      subtitle: Text('${DateFormat('yyyy-MM-dd').format(date)} ${meeting.time}'),
                      onTap: () => _showMeetingDetails(context, meeting),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ),
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate); // Format date as yyyy-MM-dd
      });
    }
  }

  Future<void> _searchMeetings() async {
    if (_searchFormKey.currentState?.validate() ?? false) {
      final dateStr = _dateController.text;
      if (dateStr.isNotEmpty) {
        // Compare only the date part by using equals
        final searchDate = dateStr;  // Keep the date part only

        // Debugging output
        print('Searching for meetings on: $searchDate');

        // Query the database for meetings with the exact date
        final query = _meetingBox.query(
          Meeting_.date.equals(searchDate),
        ).build();

        final meetings = query.find();

        print('Found ${meetings.length} meetings'); // Log the number of found meetings

        setState(() {
          _searchResults = meetings;
        });

        if (_searchResults.isEmpty) {
          print('No meetings found for the selected date.');
        }
      }
    }
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
