import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:signup/theme/theme.dart';
import 'package:signup/Meeting.dart';
import 'package:signup/objectbox_store.dart';

class CreateMeetingPage extends StatefulWidget {
  @override
  _CreateMeetingPageState createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _meetingIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _participantsCountController = TextEditingController();
  final _agendaController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<TextEditingController> _participantControllers = [];
  int _participantCount = 1;

  Box<Meeting>? _meetingBox;
  String? _storeError;

  @override
  void initState() {
    super.initState();
    _addParticipantField();
    _initStore();
  }

  @override
  void dispose() {
    for (final controller in [
      _subjectController,
      _meetingIdController,
      _locationController,
      _dateController,
      _timeController,
      _categoryController,
      _participantsCountController,
      _agendaController,
      ..._participantControllers,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _initStore() async {
    try {
      final box = await ObjectBoxStore.meetingBox();
      if (!mounted) return;
      setState(() {
        _meetingBox = box;
        _storeError = null;
      });
    } catch (error, stackTrace) {
      debugPrint('Failed to open meeting storage: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _meetingBox = null;
        _storeError = 'Could not open meeting storage: $error';
      });
    }
  }

  void _addParticipantField() {
    setState(() {
      _participantControllers.add(TextEditingController());
      _participantCount = _participantControllers.length;
    });
  }

  void _removeParticipantField(int index) {
    setState(() {
      if (_participantControllers.length > 1) {
        _participantControllers.removeAt(index);
        _participantCount = _participantControllers.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Meeting',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
      ),
      body: _storeError != null
          ? _buildStoreError()
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_subjectController, 'Subject'),
                _buildTextField(_meetingIdController, 'Meeting ID'),
                _buildTextField(_locationController, 'Location'),
                _buildDateField(),
                _buildTimeField(),
                _buildTextField(_categoryController, 'Category'),
                _buildTextField(_participantsCountController, 'No. of Participants'),
                _buildParticipantsFields(),
                _buildTextField(_agendaController, 'Agenda', maxLines: 5),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _meetingBox == null ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _storeError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() => _storeError = null);
                _initStore();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
          ),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
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
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildTimeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _timeController,
        decoration: InputDecoration(
          labelText: 'Time',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.access_time),
            onPressed: _selectTime,
          ),
        ),
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a time';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        final now = DateTime.now();
        final timeOfDay = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _timeController.text = "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Widget _buildParticipantsFields() {
    return Column(
      children: [
        for (int i = 0; i < _participantControllers.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _participantControllers[i],
                    decoration: InputDecoration(
                      labelText: 'Participant ${i + 1}',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                if (_participantControllers.length > 1)
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeParticipantField(i),
                  ),
                if (_participantControllers.length == i + 1)
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.green),
                    onPressed: _addParticipantField,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final meetingBox = _meetingBox;
    if (meetingBox == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_storeError ?? 'Meeting storage is not ready')),
      );
      return;
    }

    // Create a Meeting object with the collected data
    final meeting = Meeting(
      subject: _subjectController.text,
      meetingId: _meetingIdController.text,
      location: _locationController.text,
      date: _dateController.text,
      time: _timeController.text,
      category: _categoryController.text,
      participantsCount: _participantControllers.length,
      agenda: _agendaController.text,
      participants: _participantControllers.map((c) => c.text).toList(),
    );

    try {
      meetingBox.put(meeting);
    } catch (error, stackTrace) {
      debugPrint('Failed to save meeting: $error\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save the meeting: $error')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Meeting Created and Saved')),
    );

    // Clear the form
    _formKey.currentState?.reset();
    for (final controller in _participantControllers) {
      controller.dispose();
    }
    _participantControllers.clear();
    _addParticipantField();
  }
}
