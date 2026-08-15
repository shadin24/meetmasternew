import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:objectbox/objectbox.dart';
import 'package:signup/objectbox.g.dart' show Meeting_;
import 'package:signup/objectbox_store.dart';
import 'package:signup/theme/theme.dart';
import 'package:signup/util/utils.dart';
import '../../../Meeting.dart'; // Adjust the import according to your project structure

class SearchMeetingPage extends StatefulWidget {
  @override
  _SearchMeetingPageState createState() => _SearchMeetingPageState();
}

class _SearchMeetingPageState extends State<SearchMeetingPage> {
  final _searchFormKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;

  Box<Meeting>? _meetingBox;
  List<Meeting> _searchResults = []; // State variable for search results
  bool _searching = false;
  bool _searched = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initStore();
  }

  Future<void> _initStore() async {
    try {
      final box = await ObjectBoxStore.meetingBox();
      if (!mounted) return;
      setState(() {
        _meetingBox = box;
        _error = null;
      });
    } catch (error, stackTrace) {
      debugPrint('Failed to open meeting storage: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _error = 'Could not open meeting storage: $error';
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
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
                    onPressed: _searching ? null : _searchMeetings,
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
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_searching) {
      return Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(_searched
            ? 'No meetings found.'
            : 'Pick a date to search for meetings.'),
      );
    }
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final meeting = _searchResults[index];
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
    if (!(_searchFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final searchDate = _dateController.text;
    if (searchDate.isEmpty) {
      return;
    }

    var box = _meetingBox;
    setState(() {
      _searching = true;
      _error = null;
    });

    Query<Meeting>? query;
    try {
      box ??= await ObjectBoxStore.meetingBox();
      _meetingBox = box;
      query = box.query(Meeting_.date.equals(searchDate)).build();
      final meetings = query.find();
      if (!mounted) return;
      setState(() {
        _searchResults = meetings;
        _searching = false;
        _searched = true;
      });
    } catch (error, stackTrace) {
      debugPrint('Meeting search failed: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _searchResults = [];
        _searching = false;
        _searched = true;
        _error = 'Search failed: $error';
      });
    } finally {
      query?.close();
    }
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
