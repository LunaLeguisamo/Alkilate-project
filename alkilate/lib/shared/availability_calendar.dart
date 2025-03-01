import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityCalendar extends StatefulWidget {
  final DateTime startDay;
  final DateTime endDay;
  final List<DateTime> rentedDates;
  final Function(DateTime, DateTime)? onDateRangeSelected;

  const AvailabilityCalendar({
    super.key,
    required this.startDay,
    required this.endDay,
    required this.rentedDates,
    this.onDateRangeSelected,
  });

  @override
  AvailabilityCalendarState createState() => AvailabilityCalendarState();
}

class AvailabilityCalendarState extends State<AvailabilityCalendar> {
  late DateTime _focusedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  Set<DateTime> notAvailableDays = {};

  @override
  void initState() {
    super.initState();
    // Focus on start day or today if today is after the start day
    _focusedDay = DateTime.now().isAfter(widget.startDay)
        ? DateTime.now()
        : widget.startDay;

    // Add rented dates to unavailable days
    _addRentedDatesToUnavailable();
    _fetchUnavailableDays();
  }

  void _addRentedDatesToUnavailable() {
    // Remove time component from dates to ensure proper comparison
    setState(() {
      notAvailableDays.addAll(widget.rentedDates
          .map((date) => DateTime(date.year, date.month, date.day)));
    });
  }

  Future<void> _fetchUnavailableDays() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('reservations').get();

      // Process Firebase dates and normalize them (remove time component)
      final dates = snapshot.docs.map((doc) {
        DateTime date = (doc['date'] as Timestamp).toDate();
        return DateTime(date.year, date.month, date.day);
      }).toSet();

      setState(() {
        // Add fetched dates to unavailable days
        notAvailableDays.addAll(dates);
      });
    } catch (e) {
      print('Error fetching unavailable days: $e');
    }
  }

  // Check if date is selectable (in range and available)
  bool _isDateSelectable(DateTime day) {
    final dayWithoutTime = DateTime(day.year, day.month, day.day);

    // Check if date is within valid range
    bool isInRange = !dayWithoutTime.isBefore(widget.startDay) &&
        !dayWithoutTime.isAfter(widget.endDay);

    // Check if date is not in unavailable list
    bool isAvailable = !notAvailableDays.contains(dayWithoutTime);

    return isInRange && isAvailable;
  }

  // Check if a range contains unavailable dates
  bool _isRangeAvailable(DateTime start, DateTime end) {
    // Normalize dates
    DateTime currentDate = DateTime(start.year, start.month, start.day);
    DateTime endDate = DateTime(end.year, end.month, end.day);

    while (currentDate.compareTo(endDate) <= 0) {
      if (!_isDateSelectable(currentDate)) {
        return false;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 30)),
      lastDay: widget.endDay.add(const Duration(days: 30)),
      focusedDay: _focusedDay,

      // Range selection properties
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      rangeSelectionMode: _rangeSelectionMode,

      // Called when a day is selected
      onDaySelected: (selectedDay, focusedDay) {
        if (!_isDateSelectable(selectedDay)) return;

        setState(() {
          _focusedDay = focusedDay;
          _rangeStart = selectedDay;
          _rangeEnd = null;
          _rangeSelectionMode = RangeSelectionMode.toggledOn;
        });
      },

      // Called when a range is selected
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          _rangeStart = start;
          _rangeEnd = end;

          // Only notify parent if we have a complete range
          if (start != null && end != null) {
            if (_isRangeAvailable(start, end)) {
              if (widget.onDateRangeSelected != null) {
                widget.onDateRangeSelected!(start, end);
              }
            } else {
              // Show error message for unavailable dates in range
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selected range contains unavailable dates'),
                  duration: Duration(seconds: 2),
                ),
              );
              _rangeEnd = null; // Reset end date
            }
          }
        });
      },

      calendarFormat: CalendarFormat.month,

      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final dayWithoutTime = DateTime(day.year, day.month, day.day);

          // Determine day status
          bool isUnavailable = notAvailableDays.contains(dayWithoutTime);
          bool isOutOfRange = dayWithoutTime.isBefore(widget.startDay) ||
              dayWithoutTime.isAfter(widget.endDay);
          bool isAvailable = !isUnavailable && !isOutOfRange;

          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isUnavailable
                  ? Colors.redAccent
                  : isOutOfRange
                      ? Colors.grey[300]
                      : isAvailable
                          ? Colors.green[100]
                          : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  color: isOutOfRange
                      ? Colors.grey
                      : isUnavailable
                          ? Colors.white
                          : Colors.black,
                  fontWeight: isAvailable ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
      enabledDayPredicate: (day) {
        return _isDateSelectable(day);
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }
}
