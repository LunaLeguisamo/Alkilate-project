import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityCalendar extends StatefulWidget {
  final DateTime startDay;
  final DateTime endDay;

  const AvailabilityCalendar({
    Key? key,
    required this.startDay,
    required this.endDay,
  }) : super(key: key);

  @override
  _AvailabilityCalendarState createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Set<DateTime> not_available_days = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.startDay;
    _selectedDay = widget.startDay;
    _fetchUnavailableDays();
  }

  Future<void> _fetchUnavailableDays() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('reservations').get();
      final dates = snapshot.docs
          .map((doc) => (doc['date'] as Timestamp).toDate())
          .toSet();
      setState(() {
        not_available_days = dates;
      });
    } catch (e) {
      print("Error fetching unavailable days: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: widget.startDay,
      lastDay: widget.endDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          bool isAvailable =
              day.isAfter(widget.startDay.subtract(const Duration(days: 1))) &&
                  day.isBefore(widget.endDay.add(const Duration(days: 1))) &&
                  !not_available_days.contains(day);
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.red : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  color: isAvailable ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
