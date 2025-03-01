import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarAvailabilityWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<DateTime> unavailableDates;
  final Function(DateTime)? onDateSelected;

  const CalendarAvailabilityWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.unavailableDates,
    this.onDateSelected,
  });

  @override
  CalendarAvailabilityWidgetState createState() =>
      CalendarAvailabilityWidgetState();
}

class CalendarAvailabilityWidgetState
    extends State<CalendarAvailabilityWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Focus on start date or today if it's before the range
    _focusedDay = DateTime.now().isAfter(widget.startDate)
        ? DateTime.now()
        : widget.startDate;
  }

  // Verify if a date is unavailable
  bool _isDateUnavailable(DateTime day) {
    final DateTime dayWithoutTime = DateTime(day.year, day.month, day.day);

    return widget.unavailableDates.any((unavailableDate) {
      final dateWithoutTime = DateTime(
          unavailableDate.year, unavailableDate.month, unavailableDate.day);
      return dayWithoutTime.isAtSameMomentAs(dateWithoutTime);
    });
  }

  // Check if a date is selectable (in range and not unavailable)
  bool _isDateSelectable(DateTime day) {
    final DateTime dayWithoutTime = DateTime(day.year, day.month, day.day);

    // Check if date is within the valid range
    bool isInRange = !dayWithoutTime.isBefore(widget.startDate) &&
        !dayWithoutTime.isAfter(widget.endDate);

    // Date is selectable if it's in range AND not unavailable
    return isInRange && !_isDateUnavailable(day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Disponibilidad'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return _selectedDay != null && isSameDay(_selectedDay!, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (_isDateSelectable(selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                // Notify parent with the selected date
                if (widget.onDateSelected != null) {
                  widget.onDateSelected!(selectedDay);
                }
              }
            },
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mes',
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              headerPadding: EdgeInsets.only(top: 16.0),
              leftChevronIcon: Icon(Icons.chevron_left),
              rightChevronIcon: Icon(Icons.chevron_right),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                // Handle visual representation of different day states
                if (!_isDateSelectable(day)) {
                  // Outside range or unavailable date
                  bool isOutOfRange = day.isBefore(widget.startDate) ||
                      day.isAfter(widget.endDate);

                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: _isDateUnavailable(day)
                          ? Colors.redAccent
                          : isOutOfRange
                              ? const Color.fromARGB(73, 158, 158, 158)
                              : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isOutOfRange ? Colors.grey : Colors.white,
                          fontWeight: _isDateUnavailable(day)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }
                return null; // Default style for available days
              },
            ),
            enabledDayPredicate: (day) {
              // This controls which days can be clicked
              return _isDateSelectable(day);
            },
          ),
        ],
      ),
    );
  }
}
