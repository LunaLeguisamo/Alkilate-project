import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class CalendarEventsWidget extends StatefulWidget {
  const CalendarEventsWidget({super.key});

  @override
  _CalendarEventsWidgetState createState() => _CalendarEventsWidgetState();
}

class _CalendarEventsWidgetState extends State<CalendarEventsWidget> {
  List<calendar.Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    // Simulación de eventos
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _events = [
        calendar.Event(
          summary: 'Reunión de equipo',
          start: calendar.EventDateTime(
              dateTime: DateTime.now().add(Duration(days: 1))),
        ),
        calendar.Event(
          summary: 'Almuerzo con cliente',
          start: calendar.EventDateTime(
              dateTime: DateTime.now().add(Duration(days: 2))),
        ),
        calendar.Event(
          summary: 'Presentación de proyecto',
          start: calendar.EventDateTime(
              dateTime: DateTime.now().add(Duration(days: 3))),
        ),
        calendar.Event(
          summary: 'Revisión de código',
          start: calendar.EventDateTime(
              dateTime: DateTime.now().add(Duration(days: 4))),
        ),
        calendar.Event(
          summary: 'Entrenamiento de Flutter',
          start: calendar.EventDateTime(
              dateTime: DateTime.now().add(Duration(days: 5))),
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos del Calendario'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _events.isEmpty
              ? Center(child: Text('No hay eventos próximos'))
              : _buildCalendar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          _fetchEvents();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCalendar() {
    DateTime today = DateTime.now();
    List<DateTime> daysOfWeek = [
      DateTime(today.year, today.month, today.day - today.weekday + 1), // Lunes
      DateTime(
          today.year, today.month, today.day - today.weekday + 2), // Martes
      DateTime(
          today.year, today.month, today.day - today.weekday + 3), // Miércoles
      DateTime(
          today.year, today.month, today.day - today.weekday + 4), // Jueves
      DateTime(
          today.year, today.month, today.day - today.weekday + 5), // Viernes
      DateTime(
          today.year, today.month, today.day - today.weekday + 6), // Sábado
      DateTime(
          today.year, today.month, today.day - today.weekday + 7), // Domingo
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        DateTime day = daysOfWeek[index];
        List<calendar.Event> dayEvents = _events
            .where((event) =>
                event.start?.dateTime?.day == day.day &&
                event.start?.dateTime?.month == day.month &&
                event.start?.dateTime?.year == day.year)
            .toList();

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          color: dayEvents.isEmpty ? Colors.white : Colors.blue[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${day.day}/${day.month}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...dayEvents.map((event) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      event.summary ?? 'Sin título',
                      style: TextStyle(color: Colors.black87),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatEventDate(calendar.Event event) {
    final start = event.start?.dateTime;
    if (start == null) return 'Fecha no disponible';
    return '${start.day}/${start.month}/${start.year} ${start.hour}:${start.minute}';
  }
}
