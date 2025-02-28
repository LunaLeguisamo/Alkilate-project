import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarAvailabilityWidget extends StatefulWidget {
  const CalendarAvailabilityWidget({super.key});

  @override
  CalendarAvailabilityWidgetState createState() =>
      CalendarAvailabilityWidgetState();
}

class CalendarAvailabilityWidgetState
    extends State<CalendarAvailabilityWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Rango de fechas seleccionadas para reserva (del 20 al 25 de febrero de 2024)
  final DateTime _startAvailability = DateTime.utc(2024, 2, 20);
  final DateTime _endAvailability = DateTime.utc(2024, 2, 25);

  // Función para comprobar si un día está dentro del rango de fechas reservadas
  bool _isDateReserved(DateTime day) {
    DateTime dayStart = DateTime(day.year, day.month, day.day);
    return dayStart
            .isAfter(_startAvailability.subtract(const Duration(days: 1))) &&
        dayStart.isBefore(_endAvailability.add(const Duration(days: 1)));
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
              // Personaliza el aspecto de los días reservados
              defaultBuilder: (context, day, focusedDay) {
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return null; // Dejar el estilo predeterminado para otros días
              },
            ),
          ),
        ],
      ),
    );
  }
}
