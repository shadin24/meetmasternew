import 'package:flutter/material.dart';
import 'package:signup/Meeting.dart';
import 'package:signup/common/widgets/app_bar.dart';
import 'package:signup/common/widgets/app_text_field.dart';
import 'package:signup/common/widgets/pill_button.dart';
import 'package:signup/util/date_time_utils.dart';
import 'package:signup/util/meeting_store.dart';
import 'package:signup/util/validators.dart';

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
  final List<TextEditingController> _participantControllers = [];

  final MeetingStore _meetingStore = MeetingStore();

  @override
  void initState() {
    super.initState();
    _addParticipantField();
    _meetingStore.open(); // Initialize ObjectBox
  }

  @override
  void dispose() {
    _meetingStore.close();
    super.dispose();
  }

  void _addParticipantField() {
    setState(() {
      _participantControllers.add(TextEditingController());
    });
  }

  void _removeParticipantField(int index) {
    setState(() {
      if (_participantControllers.length > 1) {
        _participantControllers.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppScreenAppBar(title: 'Create Meeting'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                _buildTextField(
                    _participantsCountController, 'No. of Participants'),
                _buildParticipantsFields(),
                _buildTextField(_agendaController, 'Agenda', maxLines: 5),
                const SizedBox(height: 20),
                PillButton(label: 'Submit', onPressed: _submitForm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return AppTextField(
      controller: controller,
      label: label,
      maxLines: maxLines,
      validator: (value) => Validators.required(value, label),
    );
  }

  Widget _buildDateField() {
    return AppTextField(
      controller: _dateController,
      label: 'Date',
      readOnly: true,
      validator: (value) => Validators.selection(value, 'date'),
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: _selectDate,
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

  Widget _buildTimeField() {
    return AppTextField(
      controller: _timeController,
      label: 'Time',
      readOnly: true,
      validator: (value) => Validators.selection(value, 'time'),
      suffixIcon: IconButton(
        icon: const Icon(Icons.access_time),
        onPressed: _selectTime,
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await pickTime(context, _selectedTime);

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = formatTimeOfDay(pickedTime);
      });
    }
  }

  Widget _buildParticipantsFields() {
    return Column(
      children: [
        for (int i = 0; i < _participantControllers.length; i++)
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _participantControllers[i],
                  label: 'Participant ${i + 1}',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a name' : null,
                ),
              ),
              if (_participantControllers.length > 1)
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _removeParticipantField(i),
                ),
              if (_participantControllers.length == i + 1)
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: _addParticipantField,
                ),
            ],
          ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
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

      // Save to ObjectBox
      _meetingStore.box.put(meeting);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting Created and Saved')),
      );

      // Clear the form
      _formKey.currentState?.reset();
      _participantControllers.clear();
      _addParticipantField();
    }
  }
}
