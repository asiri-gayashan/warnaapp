import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_textfield.dart';

enum PickerMode { date, time, datetime, year, monthYear }

class CustomDateTimePicker extends StatelessWidget {
  final String label;
  final String hintText;
  final PickerMode mode;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Function(DateTime)? onDateSelected;
  final Function(TimeOfDay)? onTimeSelected;
  final String? errorText;

  const CustomDateTimePicker({
    Key? key,
    required this.label,
    required this.hintText,
    this.mode = PickerMode.date,
    this.selectedDate,
    this.selectedTime,
    this.onDateSelected,
    this.onTimeSelected,
    this.errorText,
  }) : super(key: key);

  Future<void> _handleTap(BuildContext context) async {
    switch (mode) {
      case PickerMode.date:
        await _pickDate(context);
        break;
      case PickerMode.time:
        await _pickTime(context);
        break;
      case PickerMode.datetime:
        await _pickDateTime(context);
        break;
      case PickerMode.year:
        await _pickYear(context);
        break;
      case PickerMode.monthYear:
        await _pickDate(context);
        break;
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null && onDateSelected != null) {
      onDateSelected!(date);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time != null && onTimeSelected != null) {
      onTimeSelected!(time);
    }
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time == null) return;

    if (onDateSelected != null) {
      final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      onDateSelected!(dateTime);
    }
  }

  Future<void> _pickYear(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              selectedDate: selectedDate ?? DateTime.now(),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context);
                if (onDateSelected != null) onDateSelected!(dateTime);
              },
            ),
          ),
        );
      },
    );
  }

  String _getFormattedText() {
    if (mode == PickerMode.time && selectedTime != null) {
      final dummyDate = DateTime(2000, 1, 1, selectedTime!.hour, selectedTime!.minute);
      return DateFormat('hh:mm a').format(dummyDate);
    }
    if (selectedDate == null) return hintText;

    switch (mode) {
      case PickerMode.date:
        return DateFormat('yyyy-MM-dd').format(selectedDate!);
      case PickerMode.year:
        return DateFormat('yyyy').format(selectedDate!);
      case PickerMode.monthYear:
        return DateFormat('MMMM yyyy').format(selectedDate!);
      case PickerMode.datetime:
        return DateFormat('yyyy-MM-dd hh:mm a').format(selectedDate!);
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.calendar_today;
    if (mode == PickerMode.time) icon = Icons.access_time;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: label,
          hintText: _getFormattedText(),
          readOnly: true,
          onTap: () => _handleTap(context),
          suffixIcon: Icon(icon, color: Colors.grey),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
