import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarAvailabilityWidget extends StatefulWidget {
  const CalendarAvailabilityWidget({super.key});

  @override
  _CalendarAvailabilityWidgetState createState() =>
      _CalendarAvailabilityWidgetState();
}

class _CalendarAvailabilityWidgetState
    extends State<CalendarAvailabilityWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Rango de fechas seleccionadas para reserva (de 20 a 25 de febrero)
  final DateTime _startAvailability = DateTime.utc(2024, 2, 20);
  final DateTime _endAvailability = DateTime.utc(2024, 2, 25);

  // Función para comprobar si un día está dentro del rango de fechas de reserva
  bool _isDateReserved(DateTime day) {
    // Ignorar la hora para comparación
    DateTime dayStart = DateTime(day.year, day.month, day.day);
    DateTime startAvailability = DateTime(_startAvailability.year,
        _startAvailability.month, _startAvailability.day);
    DateTime endAvailability = DateTime(
        _endAvailability.year, _endAvailability.month, _endAvailability.day);

    return dayStart.isAfter(startAvailability.subtract(Duration(days: 1))) &&
            dayStart.isBefore(endAvailability.add(Duration(days: 1))) ||
        dayStart.isAtSameMomentAs(startAvailability) ||
        dayStart.isAtSameMomentAs(endAvailability);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendario de Disponibilidad')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                // Marcar en rojo los días reservados
                if (_isDateReserved(day)) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.redAccent, // Rojo para días reservados
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
